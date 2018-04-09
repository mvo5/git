#!/bin/sh

test_description='Test git show works'

. ./test-lib.sh

test_expect_success 'verify git show HEAD:foo works' '
    printf "foo content\n" >foo &&
    git add foo &&
    git commit -m "added foo" &&
    git show HEAD:foo >actual &&
    printf "foo content\n" >expected &&
    test_cmp expected actual
'

test_expect_success 'verify git show HEAD:symlink shows symlink points to foo' '
    echo "foo content" >foo &&
    ln -s foo symlink &&
    git add foo symlink &&
    git commit -m "added foo and a symlink to foo" &&
    git show HEAD:foo >actual &&
    printf "foo content\n" >expected &&
    test_cmp expected actual &&
    git show HEAD:symlink >actual && 
    printf "foo" >expected &&
    test_cmp expected actual
'

test_expect_success 'verify git show --follow-symlinks HEAD:symlink shows foo' '
    git show --follow-symlinks HEAD:symlink >actual &&
    printf "foo content\n" >expected &&
    test_cmp expected actual
'

test_expect_success 'verify git show --follow-symlinks HEAD:symlink works with subdirs' '
    mkdir dir &&
    ln -s dir symlink-to-dir &&
    printf "bar content\n" >dir/bar &&
    git add dir symlink-to-dir &&
    git commit -m "add dir and symlink-to-dir" &&
    git show --follow-symlinks HEAD:symlink-to-dir/bar >actual &&
    printf "bar content\n" >expected &&
    test_cmp expected actual
'

test_done
