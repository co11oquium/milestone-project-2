
# Vista.vim

[![CI](https://github.com/liuchengxu/vista.vim/workflows/ci/badge.svg)](https://github.com/liuchengxu/vista.vim/actions?workflow=ci)

View and search LSP symbols, tags in Vim/NeoVim.

<p align="center">
    <img width="600px" src="https://user-images.githubusercontent.com/8850248/56469894-14d40780-6472-11e9-802f-729ac53bd4d5.gif">
    <p align="center">Vista ctags</p>
</p>

[>>>> More screenshots](https://github.com/liuchengxu/vista.vim/issues/257)

**caveat: There is a major flaw about the tree view renderer of ctags at the moment, see [#320](https://github.com/liuchengxu/vista.vim/issues/320) for more details.**

## Table Of Contents

<!-- TOC GFM -->

* [Introduction](#introduction)
* [Features](#features)
* [Requirement](#requirement)
* [Installation](#installation)
    * [Plugin Manager](#plugin-manager)
    * [Package management](#package-management)
        * [Vim 8](#vim-8)
        * [NeoVim](#neovim)
* [Usage](#usage)
    * [Show the nearest method/function in the statusline](#show-the-nearest-methodfunction-in-the-statusline)
        * [lightline.vim](#lightlinevim)
    * [Commands](#commands)
    * [Options](#options)
    * [Other tips](#other-tips)
        * [Compile ctags with JSON format support](#compile-ctags-with-json-format-support)
* [Contributing](#contributing)
* [License](#license)

<!-- /TOC -->

## Introduction
