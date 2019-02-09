import requests;
import core.stdc.stdlib;
import std.conv;
import std.csv;
import std.digest.sha;
import std.file;
import std.stdio;
import std.string;
import std.uni;

void main(string[] args)
{
    if (args.length < 2) {
        writeln("Please provide a CSV with a column 'password' and additional columns.");
        exit(1);
    }

    string inputFile = args[1];
    auto data = readText(inputFile);

    auto rq = new Request();
    string pwHeader = null;
    foreach (record; csvReader!(string[string])(data, null))
    {
        if (pwHeader == null)
        {
            foreach (header; record.keys)
            {
                if (header.sicmp("password") == 0)
                {
                    pwHeader = header;
                    break;
                }
            }

            if (pwHeader == null)
            {
                writeln("Invalid CSV. Please provide a 'password' column.");
                exit(1);
            }
        }

        auto pwHash = toHexString(sha1Of(record[pwHeader]));

        auto rs = rq.get("https://api.pwnedpasswords.com/range/" ~ pwHash[0..5].to!string);

        if (rs.code == 200)
        {
            string responseData = cast(string)rs.responseBody.data;

            if (responseData.indexOf(pwHash[5..$], No.caseSensitive) > -1)
            {
                writeln("The password for the following entry was pwned!");
                foreach (key; record.keys)
                {
                    if (key != pwHeader) writeln(key ~ ": " ~ record[key]);
                }
            }
        }
        else
        {
            writeln("Failed to check the following entry (returned status code " ~ rs.code.to!string ~ "):");
            foreach (key; record.keys)
            {
                if (key != pwHeader) writeln(key ~ ": " ~ record[key]);
            }
        }
    }
}
