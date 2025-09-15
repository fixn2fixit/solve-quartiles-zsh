# solve-quartiles-zsh
# Solve Apple News+ Quartiles Puzzles with Z-shell
# README: README file, ver. 2.6.xx
# SCRIPT: solve-quartiles.zsh
# Author: Mike Carney
# email : fixn2fixit@gmail.com
# Date  : September 15, 2025
# 
# PURPOSE
# -------
# Solves Apple News+ Quartiles puzzles
# Avoids human meltdown arranging 123,520 combinations
#
# INSTALL/USE
# -----------
# Expected install PATH is user's $HOME
# Zsh must be installed or add that package first
# Bundled: the zsh script, wordlist.txt, tiles.txt, tiles.test
# Download qt_distro_12.tar.gz
# Unzip and untar
# QT_DISTRO_12 directory will be created with all you need
# cd QT_DISTRO_12
# then type: zsh solve-quartiles.zsh

# TO PLAY 
# -------
# On Apple News+ Puzzles, find a Quartiles puzzle to solve
# Initial run asks for input (goes into tiles.txt), enter all 20 tiles
# If instead you enter a single period, the current (tiles.txt) file is used
# (tiles.txt) must have (20) tiles total, space-delimited, one or more lines
# Intended/bundled (tiles.test) can be used to copy to (tiles.txt) for demo

# OPTIONAL
# -------- 
# Try an OCR app to scan the 20 tiles together
# then copy/paste the entire group for input
#
# DEVELOPMENT IDEAS IMPLEMENTED 
# -----------------------------
# No special libraries, no database, nothing exotic
# No OS unique utilities (Linux vs. MacOS)
# Minimize file searches, use memory arrays primarily
# Must input 20 tiles (full tiles space-separated)
# Use standard command-line tools only, shell and regex
# Locate a reliable wordplay wordlist from GitHub, etc.
# Include such wordlist in the install disto
# Since any particular wordlist is likely imperfect,
# (add/del) words as puzzles reveal over days/months, etc.
# wordlist.txt will be updated regularly for this project
# 
# LATER IMPLEMENTED
# -----------------
# Added checks, wordlist compatibility and tiles content
# Sorting tiles by wordlist frequency increased speed in most cases
# (4-tile words) do not reuse tiles, dynamically exclude those used
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
