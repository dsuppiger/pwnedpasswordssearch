# Pwned Passwords Search

This is a command line tool to check a list of passwords from a CSV file against the [Have I been Pwned](https://haveibeenpwned.com/Passwords) service.

## Compiling

The project uses the [DUB package manager](https://dub.pm/getting_started).

## Usage

The command line tool takes a CSV file as the only argument. The CSV files must have a column 'passwords' and at least one additional column (e.g. with the URL, service or username to which the password belongs).