# BrewDG

Homebrew Dependency Graphs.

BrewDG allows you to visualize your homebrew package dependencies, and can give you a list of packages in an order which minimizes the amount of dependency installation required by subsequent packages.

## Installation

`gem install brew_dg`

## Synopsis

    brew_dg [options] [package package ...]

## Description

Assuming for the moment that brew_dg is given no options, for each
package given, brew_dg will display that package, along with its
Required and Recommended dependencies. brew_dg orders the packages such
that a given package will not be installed until its Recommended and
Required dependencies have been installed.

If no options or pacakges are given, brew_dg displays any homebrew
packages you've installed, along with any uninstalled, Recommended
dependencies in an order such that a package will not be installed until
its dependencies have been installed.

The following options allow users to configure and tweak the details of the
preceeding description:

    -a
        Display all dependencies, including Optional and Build dependencies.

    -o [file]
        Draw graph, and write it to file. Directed edges are read as "depends
        on." If given a directory $DIR, the file will be located at
        $DIR/library.png. If given no argument, the file will be written to
        STDOUT. See Graph section for stylistic details.

    -O [file]
        Draw inverted graph, and write it to file. Directed edges are read as
        "is a dependency of." If given a directory $DIR, the file will be
        located at $DIR/library.png. If given no argument, the file will be
        written to STDOUT. See Graph section for stylistic details.

    -t types
        Display only dependencies of the comma-delimited types specified. e.g.
        `-t Recommended,Optional'

## Graph

The graph uses edge and arrow styles to differentiate between dependency
types.

    Required:    A solid edge with a filled, triangular arrow.
    Recommended: A solid edge with an empty, triangular arrow.
    Optional:    A dotted edge with a filled, triangular arrow.
    Build:       A dotted edge with a tee-shaped arrow.

