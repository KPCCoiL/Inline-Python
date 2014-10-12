class Inline::Python;

use NativeCall;

sub native(Sub $sub) {
    my $so = 'pyhelper.so';
    state Str $path;
    unless $path {
        for @*INC {
            if "$_/Inline/$so".IO ~~ :f {
                $path = "$_/Inline/$so";
                last;
            }
        }
    }
    unless $path {
        die "unable to find Inline/$so IN \@*INC";
    }
    trait_mod:<is>($sub, :native($path));
}

sub py_init_python()
    { ... }
    native(&py_init_python);
sub py_eval(Str, Int)
    returns OpaquePointer { ... }
    native(&py_eval);
sub py_int_check(OpaquePointer)
    returns int32 { ... }
    native(&py_int_check);
sub py_unicode_check(OpaquePointer)
    returns int32 { ... }
    native(&py_unicode_check);
sub py_string_check(OpaquePointer)
    returns int32 { ... }
    native(&py_string_check);
sub py_int_as_long(OpaquePointer)
    returns Int { ... }
    native(&py_int_as_long);
sub py_unicode_to_char_star(OpaquePointer)
    returns Str { ... }
    native(&py_unicode_to_char_star);
sub py_string_to_buf(OpaquePointer, CArray[CArray[int8]])
    returns Int { ... }
    native(&py_string_to_buf);

method py_to_p6(OpaquePointer $value) {
    if py_int_check($value) {
        return py_int_as_long($value);
    }
    elsif py_unicode_check($value) {
        return py_unicode_to_char_star($value);
    }
    elsif py_string_check($value) {
        my $string_ptr = CArray[CArray[int8]].new;
        $string_ptr[0] = CArray[int8];
        my $len = py_string_to_buf($value, $string_ptr);
        my $buf = Buf.new;
        for 0..^$len {
            $buf[$_] = $string_ptr[0][$_];
        }
        return $buf;

    }
    return Any;
}

multi method run($python, :$eval!) {
    my $res = py_eval($python, 0);
    self.py_to_p6($res);
}

multi method run($python, :$file) {
    my $res = py_eval($python, 1);
    self.py_to_p6($res);
}

method BUILD {
    py_init_python();
}
