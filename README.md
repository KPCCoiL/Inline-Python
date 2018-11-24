# TITLE

Inline::Python3

This module will be Python3 version of [Inline::Python](https://github.com/niner/Inline-Python).
However, the work is in progress -- it won't work at all now.

# SYNOPSIS

```
    use Inline::Python3;
    my $py = Inline::Python3.new();
    $py.run('print("hello world")');

    # Or
    say EVAL('1+3', :lang<Python3>);

    use string:from<Python3>;
    say string::capwords('foo bar'); # prints "Foo Bar"
```

# DESCRIPTION

Module for executing Python3 code and accessing Python libraries from Perl 6.

# BUILDING

You will need a Python3 built with the -fPIC option (position independent
code). Most distributions build their Python that way. To do this with pyenv,
use something like:

```
    PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.1
    pyenv global 3.7.1
    pyenv rehash
```

With a python3 in your path, then build:


```
    perl6 configure.pl6
    make test
    make install
```

# AUTHOR

CoiL

# ACKNOWLEDGEMENT

This package started as a fork of [Inline::Python](https://github.com/niner/Inline-Python).
