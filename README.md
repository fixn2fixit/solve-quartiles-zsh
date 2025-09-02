# solve-quartiles-zsh
# Solve Apple News+ Quartiles Puzzles with Z-shell
# README: README file, ver. 2.6.xx
# SCRIPT: solve-quartiles.zsh
# Author: Mike Carney
# email : fixn2fixit@gmail.com
# Date  : August 31, 2025
# 
# DEVELOPMENT IDEAS IMPLEMENTED 
# -----------------------------
# Type 20 puzzle tiles (space-separated) for input
# Optional: try an OCR app to scan 20 tiles as a bunch
#         : then copy/paste the entire bunch for input
# Uses standard command-line tools only, shell and regex
# Requires: a reliable wordplay wordlist from GitHub, etc.
# Wordlist: wordlists are imperfect, (add/del) words
#         : as puzzles progress over days/months, etc.
#
# INSTALL/USE
# -----------
# Expected install PATH is user's $HOME
# Download qt_distro_12.tar.gz
# Unzip and untar
# A QT_DISTRO_12 directory will be created with all you need
# cd QT_DISTRO_12
# Zsh must be installed, or first add that package, 
# On Apple News+ Puzzles, find a Quartiles puzzle to solve
# then, type: zsh solve-quartiles.zsh
# Bundled: the zsh script, wordlist.txt, tiles.txt, tiles.test
# No additional libraries, no database, nothing exotic
# Avoided OS unique utilities Linux vs. MacOS
# Optimized small file searches, used memory arrays primarily
# 
# LATER IMPLEMENTED
# -----------------
# Added checks, wordlist compatibility and tiles content
# 
# PROBLEMATIC
# -----------
# Using an OCR scan is imperfect, can introduce multi-byte chars
# Multi-byte character cleanup is an elusive conundrum
# Wordlists for download are predominately DOS formatted
# wordlist.txt gets scrubbed, keep any originals you overwrite with
# Standard -nix utilities don't play well with CRLF terminated files
# 
# SETTLED ON ZSH OVER BASH
# ------------------------
# zsh is faster, coding is familiar to bash in most respects
# However, zsh array elements count from 1, bash from 0
# I avoided {braces} syntax where possible for simplicity 
# 
# MY DEV KIT
# ----------
# Mac mini, 2018 I7, 64GB, BlackMagic GPU, Sonoma 14
# Beelink SER 7 mini PC, 64GB, Ryzen 7840, Ubuntu 24
#
# BENCHMARKS
# ----------
# Ran puzzles gathered over 250+ days
# MacOS: Intel I7    (1.0)-(4.0) sec, < 1.9 > avg
# Linux: Ryzen 7840  (0.3)-(1.5) sec, < 0.5 > avg
#
