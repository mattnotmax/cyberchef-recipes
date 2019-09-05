# CyberChef Recipes

A list of CyberChef recipes 

For background see Twitter #cyberchef or https://bitofhex.com/2018/05/29/cyberchef/

Full credit to @GCHQ for producing the tool. See: https://gchq.github.io/CyberChef/

[Recipe 1: Extract base64, raw inflate & beautify](#recipe-1---extract-base64-raw-inflate-and-code-beautify)

[Recipe 2: Invoke Obfuscation](#recipe-2---invoke-obfuscation)

[Recipe 3: From CharCode](#recipe-3---from-charcode)

[Recipe 4: Group Policy Preference Password Decryption](#recipe-4---group-policy-preference-passwords)

[Recipe 5: Using Loops and Labels](#recipe-5---using-loops--labels)

[Recipe 6: Google ei Timestamps](#recipe-6---google-ei-timestamp)

[Recipe 7: Multi-stage COM scriplet to x86 assembly](#recipe-7---com-scriplet-to-disassembled-x86-assembly)

[Recipe 8: - Extract hexadecimal, convert to hexdump for embedded PE file](#recipe-8---extract-hexadecimal-convert-to-hexdump-for-embedded-pe-file)

[Recipe 9 - Reverse strings, character substitution, from base64](#recipe-9---reverse-strings-character-substitution-from-base64)

[Recipe 10 - Extract object from Squid proxy cache](#recipe-10---extract-object-from-squid-proxy-cache)

[Recipe 11 - Extract GPS Coordinates to Google Maps URLs](#recipe-11---extract-gps-coordinates-to-google-maps-urls)

[Recipe 12 - Big Number Processing](#recipe-12---big-number-processing)

[Recipe 13 - Parsing DNS PTR records with Registers](#recipe-13---parsing-dns-ptr-records-with-registers)

[Recipe 14 - Decoding POSHC2 executables](#recipe-14---decoding-poshc2-executables)

[Recipe 15 - Parsing $MFT $SI Timestamps](#recipe-15---parsing-mft-si-timestamps)

[Recipe 16 - Decoding PHP gzinflate and base64 webshells](#recipe-16---decoding-php-gzinflate-and-base64-webshells)

[Recipe 17 - Extracting shellcode from a Powershell Meterpreter Reverse TCP Script](#recipe-17---extracting-shellcode-from-a-powershell-meterpreter-reverse-tcp-script)

[Recipe 18 - Recycle Bin Parser with Subsections and Merges](#recipe-18---recycle-bin-parser-with-subsections-and-merges)

[Recipe 19 - Identify Obfuscated Base64 with Regular Expression Highlighting](#recipe-19---identify-obfuscated-base64-with-regular-expression-highlighting)

[Recipe 20 - Using Yara rules with deobfuscated malicious scripts](#recipe-20---using-yara-rules-with-deobfuscated-malicious-scripts)

## Recipe 1 - Extract base64, raw inflate and code beautify

A very common scenario: extract Base64, inflate, beautify the code. You may need to then do further processing or dynamic analysis depending on the next stage.

Filename: ahack.bat

Zipped File: cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54_183SnuOIVa.bin.gz

Sample: SHA256 cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54

https://www.hybrid-analysis.com/sample/cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54?environmentId=120

### Recipe Details

```[{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Adaptive",false,false]},{"op":"Generic Code Beautify","args":[]}]```

![Recipe_1](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_1.PNG)


## Recipe 2 - Invoke-Obfuscation

CyberChef won't be able to handle all types of Invoke-Obfuscation, but here is one that can be decoded.

Filename: Acknowledgement NUT-95-52619.eml

Zipped File: 1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835.bin.gz

Sample: SHA256 1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835

https://www.hybrid-analysis.com/sample/1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835?environmentId=120


### Recipe Details

```[{"op":"Find / Replace","args":[{"option":"Regex","string":"\\^|\\\\|-|_|\\/|\\s"},"",true,false,true,false]},{"op":"Reverse","args":["Character"]},{"op":"Generic Code Beautify","args":[]},{"op":"Find / Replace","args":[{"option":"Simple string","string":"http:"},"http://",true,false,true,false]},{"op":"Extract URLs","args":[false]},{"op":"Defang URL","args":[true,true,true,"Valid domains and full URLs"]}]```

![Recipe_2](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_2.PNG)

## Recipe 3 - From CharCode

Malware and scripts often use Charcode to represent characters in order to evade from AV and EDR solutions. CyberChef eats this up.

Filename: 3431818-f71f60d10b1cbe034dc1be242c6efa5b9812f3c6.zip

Source: https://gist.github.com/jonmarkgo/3431818

### Recipe Details

```[{"op":"Regular expression","args":["User defined","([0-9]{2,3}(,\\s|))+",true,true,false,false,false,false,"List matches"]},{"op":"From Charcode","args":["Comma",10]},{"op":"Regular expression","args":["User defined","([0-9]{2,3}(,\\s|))+",true,true,false,false,false,false,"List matches"]},{"op":"From Charcode","args":["Space",10]}]```

![Recipe_3](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_3.PNG)

## Recipe 4 - Group Policy Preference passwords

When a new GPP is created, there’s an associated XML file created in SYSVOL with the relevant configuration data and if there is a password provided, it is AES-256 bit encrypted. Microsoft published the AES Key, which can be used to decrypt passwords store in:  \\<DOMAIN>\SYSVOL\<DOMAIN>\Policies\

Credit: @cyb3rops

Source 1: https://twitter.com/cyb3rops/status/1036642978167758848

Source 2: https://adsecurity.org/?p=2288

### Recipe Details

```[{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hex","args":["None"]},{"op":"AES Decrypt","args":[{"option":"Hex","string":"4e9906e8fcb66cc9faf49310620ffee8f496e806cc057990209b09a433b66c1b"},{"option":"Hex","string":""},"CBC","Hex","Raw",{"option":"Hex","string":""}]},{"op":"Decode text","args":["UTF16LE (1200)"]}]```

![Recipe_4](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_4.PNG)

## Recipe 5 - Using loops & labels

CyberChef can use labels to identify parts of the recipe and then loop back to perform operations multiple times. In this examples, there are 29 rounds of Base64 encoding which are extracted and decoded.

Credit: @pmelson

Source File: hmCPDnHs.txt

Source 1: https://pastebin.com/hmCPDnHs

Source 2: https://twitter.com/pmelson/status/1078776229996752896

Also see more example of loops over Base64: https://twitter.com/QW5kcmV3/status/1079095274776289280 (Credit: @QW5kcmV3)

### Recipe Details

```[{"op":"Label","args":["top"]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Adaptive",false,false]},{"op":"Jump","args":["top",28]},{"op":"Generic Code Beautify","args":[]}]```

![Recipe_5](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_5.PNG)


## Recipe 6 - Google ei timestamp

Google uses its own timestamp, I call ei time, which it embeds in the URL.

Source: https://bitofhex.com/2018/05/29/cyberchef/

### Recipe Details

```[{"op":"From Base64","args":["A-Za-z0-9-_=",true]},{"op":"To Hex","args":["None"]},{"op":"Take bytes","args":[0,8,false]},{"op":"Swap endianness","args":["Hex",4,true]},{"op":"From Base","args":[16]},{"op":"From UNIX Timestamp","args":["Seconds (s)"]}]```

![Recipe_6](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_6.PNG)

## Recipe 7 - COM scriplet to disassembled x86 assembly

This is an eleven stage decoded COM scriplet that uses Base64, Gunzip, RegEx, and Disassemble x86 instructions.

Credit: @JohnLaTwC

Filename: 41a6e22ec6e60af43269f4eb1eb758c91cf746e0772cecd4a69bb5f6faac3578.txt

Source 1: https://gist.githubusercontent.com/JohnLaTwC/aae3b64006956e8cb7e0127452b5778f/raw/f1b23c84c654b1ea60f0e57a860c74385915c9e2/43cbbbf93121f3644ba26a273ebdb54d8827b25eb9c754d3631be395f06d8cff

Source 2: https://twitter.com/JohnLaTwC/status/1062419803304976385

### Recipe Details

```[{"op":"Regular expression","args":["","[A-Za-z0-9=/]{40,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Remove null bytes","args":[]},{"op":"Regular expression","args":["User defined","[A-Za-z0-9+/=]{40,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Gunzip","args":[]},{"op":"Regular expression","args":["User defined","[A-Za-z0-9+/=]{40,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hex","args":["Space"]},{"op":"Remove whitespace","args":[true,true,true,true,true,false]},{"op":"Disassemble x86","args":["32","Full x86 architecture",16,0,true,true]}]```

![Recipe_7](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_7.png)

## Recipe 8 - Extract hexadecimal, convert to hexdump for embedded PE file

This file has an embedded PE file (SHA 256: 26fac1d4ea12cdceac0d64ab9694d0582104b3c84d7940a4796c1df797d0fdc2, R5Sez8PH.exe, VT: 54/70). Using CyberChef, we can regex hexadecimal and the convert to a more easily viewable hexdump.

Source 1: https://pastebin.com/R5Sez8PH

Source 2: https://twitter.com/ScumBots/status/1081949877272276992

### Recipe Details

```[{"op":"Regular expression","args":["User defined","[a-fA-F0-9]{200,}",true,true,false,false,false,false,"List matches"]},{"op":"From Hex","args":["Auto"]},{"op":"To Hexdump","args":[16,false,false]}]```

![Recipe_8](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_8.png)

## Recipe 9 - Reverse strings, character substitution, from base64

A blob of base64 with some minor bytes to be substituted. Original decoding done by @pmelson in Python and converted to CyberChef.

Credit: @pmelson

Source 1: https://pastebin.com/RtjrweYF

Source 2: https://twitter.com/pmelson/status/1076893022758100998

### Recipe Details

```[{"op":"Reverse","args":["Character"]},{"op":"Find / Replace","args":[{"option":"Regex","string":"%"},"A",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"×"},"T",true,false,false,false]},{"op":"Find / Replace","args":[{"option":"Simple string","string":"÷"},"V",true,false,false,false]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hexdump","args":[16,false,false]}]```

![Recipe_9](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_9.png)


## Recipe 10 - Extract object from Squid proxy cache

Don't manually carve out your Squid cache objects. Simply upload the file to CyberChef. This recipe will search for the magic bytes 0x0D0A0D0A, extract everything after. It then gzip decompresses the object for download.

Source: 00000915 (output should be TrueCrypt_Setup_7.1a.exe with SHA256 e95eca399dfe95500c4de569efc4cc77b75e2b66a864d467df37733ec06a0ff2)

### Recipe Details

```[{"op":"To Hex","args":["None"]},{"op":"Regular expression","args":["User defined","(?<=0D0A0D0A).*$",true,false,false,false,false,false,"List matches"]},{"op":"From Hex","args":["Auto"]},{"op":"Gunzip","args":[]}]```

![Recipe_10](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_10.png)

## Recipe 11 - Extract GPS Coordinates to Google Maps URLs

If you need to quickly triage where a photo was taken and you're lucky enought to have embedded GPS latitude and longitudes then use this recipe to quickly make a usable Google Maps URL to identify the location.

### Recipe Details

```[{"op":"Extract EXIF","args":[]},{"op":"Regular expression","args":["User defined","((?<=GPSLatitude:).*$)|((?<=GPSLongitude: ).*$)",true,true,false,false,false,false,"List matches"]},{"op":"Find / Replace","args":[{"option":"Extended (\\n, \\t, \\x...)","string":"\\n"},",",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Simple string","string":" "},"https://maps.google.com/?q=",true,false,true,false]}]```

![Recipe_11](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_11.png)

## Recipe 12 - Big Number Processing

CyberChef can handle massive numbers. Here we can use a simple recipe to change a 38-digit X509SerialNumber to its hexadecimal equivalent X.509 certificate serial number. Then we can regex the hexadecimal and insert a colon to transform it to the correct format.

Credit: @QW5kcmV3

Source: https://twitter.com/QW5kcmV3/status/949437437473968128

### Recipe Details

```[{"op":"To Base","args":[16]},{"op":"Regular expression","args":["User defined","[a-f0-9]{2,2}",true,true,false,false,false,false,"List matches"]},{"op":"Find / Replace","args":[{"option":"Extended (\\n, \\t, \\x...)","string":"\\n"},":",true,false,true,false]}]```

![Recipe_12](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_12.png)

## Recipe 13 - Parsing DNS PTR records with Registers

IP addresses in DNS PTR records are stored as least significant octet first. For example: 167.139.44.10.in-addr.arpa would relate to IP address of 10.44.139.167. Using CyberChef's registers we can allocate each octet to a memory register (or variable if it's easier to think of it that way). These can then be reversed to re-order the IP address. A find/replace tidies up the rest of the record. This could be reversed it you wanted to translate 'regular' IP addresses to search in DNS PTR records. 

![Recipe_13](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_13.png)

### Recipe Details

```[{"op":"Fork","args":["\\n","\\n",false]},{"op":"Register","args":["(\\d{1,3}).(\\d{1,3}).(\\d{1,3}).(\\d{1,3})",true,false,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"$R0.$R1.$R2.$R3"},"$R3.$R2.$R1.$R0",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":".in-addr.arpa"},"",true,false,true,false]}]```

## Recipe 14 - Decoding POSHC2 executables

PoshC2 is a proxy aware C2 framework that utilises Powershell to aid penetration testers with red teaming, post-exploitation and lateral movement. The dropper is based on PowerShell and consists of a PowerShell script which is double Base64 encoded and compressed. Extracting the strings can be done with CyberChef as detailed below. Depending on the settings and customisation of the executable you may need to adjust your recipe. 

Credit: @a_tweeter_user

Source: https://twitter.com/a_tweeter_user/status/1100751236687642624

Source: posh.zip (password: 'infected'. NB: this is different to the tweeted executable by @a_tweeter_user as I don't have a VT account)

![Recipe_14](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_14.png)

### Recipe Details

```[{"op":"Strings","args":["All",4,"Alphanumeric + punctuation (A)",false]},{"op":"Remove null bytes","args":[]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+=]{200,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Remove null bytes","args":[]},{"op":"Regular expression","args":["User defined","[a-z0-9/\\\\+=]{100,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Adaptive",false,false]}]```

## Recipe 15 - Parsing $MFT $SI Timestamps

CyberChef can do just about anything with data. Here are raw hex bytes from a $MFT entry. By selecting certain bytes, and using various functions of CyberChef I can parse any part of the data as needed. This recipe will extract and parse the $SI timestamps. Encase no more!

![Recipe 15](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_15.PNG)

### Recipe Details

```[{"op":"Take bytes","args":[160,64,false]},{"op":"Regular expression","args":["User defined",".{16}",true,true,true,false,false,false,"List matches with capture groups"]},{"op":"Fork","args":["\\n","\\n",false]},{"op":"Swap endianness","args":["Hex",10,true]},{"op":"Remove whitespace","args":[true,true,true,true,true,false]},{"op":"Windows Filetime to UNIX Timestamp","args":["Nanoseconds (ns)","Hex"]},{"op":"From UNIX Timestamp","args":["Nanoseconds (ns)"]},{"op":"Merge","args":[]},{"op":"Register","args":["(.*)\\n(.*)\\n(.*)\\n(.*)",true,false,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"$R0"},"$SI Creation Time: $R0",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"$R1"},"$SI Modified Time: $R1",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"$R2"},"$SI MFT Change Time: $R2",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"$R3"},"$SI Access Time: $R3",false,false,true,false]}]```

## Recipe 16 - Decoding PHP gzinflate and base64 webshells

Webshells come in all shapes and sizes. For PHP webshells the combination of gzinflate and base64 can be used to obfuscate the eval data. In this example, there are 21 rounds of compression and base64 that we can quickly parse out using labels and loops.

Source: https://github.com/LordWolfer/webshells/blob/b7eefaff64049e3ff61e90c850686135c0ba74c4/from_the_wild1.php

![Recipe 16](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_16.PNG)

### Recipe Details

```[{"op":"Label","args":["start"]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9=/+]{10,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Block",false,false]},{"op":"Jump","args":["start",21]}]```

## Recipe 17 - Extracting shellcode from a Powershell Meterpreter Reverse TCP script

Often seen in @pmelson's Pastbin bot @scumbots, this peels away multiple layers of an encoded Powershell script to display the shellcode. From here you *could* extract PUSH statements to try and identify the IP address & port, but you'll get too many false positives. So you're better off using a tool like scdbg (see: http://sandsprite.com/blogs/index.php?uid=7&pid=152)

Source: https://twitter.com/ScumBots/status/1121854255898472453

Source: https://pastebin.com/9DnD6t6W

![Recipe 17](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_17.PNG)

### Recipe Details

```[{"op":"Regular expression","args":["User defined","[a-zA-Z0-9=/+]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Remove null bytes","args":[]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9=/+]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Gunzip","args":[]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9=/+]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hex","args":["None"]},{"op":"Disassemble x86","args":["32","Full x86 architecture",16,0,true,true]}]```


## Recipe 18 - Recycle Bin Parser with Subsections and Merges

Subsections and Merges are powerful tools in CyberChef that allow the application of ingredients to a selection of data rather than the whole input file. This section can then be merged together to continue on the whole input. In an awesome piece of work @GlassSec has created a Windows Recycle Bin parser using CyberChef indicating the possibilities of these functions is endless.

Source: https://gist.github.com/glassdfir/f30957b314ec39a8aa319420a29ffc76

Credit: https://twitter.com/GlassSec

![Recipe 18](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_18.PNG)

### Recipe Details

```[{"op":"Conditional Jump","args":["^(\\x01|\\x02)",true,"Error",10]},{"op":"Find / Replace","args":[{"option":"Regex","string":"^(\\x02.{23})(....)"},"$1",false,false,false,false]},{"op":"Subsection","args":["^.{24}(.*)",true,true,false]},{"op":"Decode text","args":["UTF16LE (1200)"]},{"op":"Find / Replace","args":[{"option":"Regex","string":"^(.*)."},"\\nDeleted File Path: $1",false,false,false,false]},{"op":"Merge","args":[]},{"op":"Subsection","args":["^.{16}(.{8})",false,true,false]},{"op":"Swap endianness","args":["Raw",8,true]},{"op":"To Hex","args":["None"]},{"op":"Windows Filetime to UNIX Timestamp","args":["Seconds (s)","Hex"]},{"op":"From UNIX Timestamp","args":["Seconds (s)"]},{"op":"Find / Replace","args":[{"option":"Regex","string":"^(.* UTC)"},"\\nFile Deletion Time: $1",true,false,true,false]},{"op":"Merge","args":[]},{"op":"Subsection","args":["^.{8}(.{8})",true,true,false]},{"op":"To Hex","args":["None"]},{"op":"Swap endianness","args":["Hex",8,true]},{"op":"From Base","args":[16]},{"op":"Find / Replace","args":[{"option":"Regex","string":"^(.*)"},"\\nDeleted File Size: $1 bytes",true,false,true,true]},{"op":"Merge","args":[]},{"op":"Find / Replace","args":[{"option":"Regex","string":"^.{8}"},"******** WINDOWS RECYCLE BIN METADATA ********",true,false,false,false]},{"op":"Jump","args":["Do Nothing",10]},{"op":"Label","args":["Error"]},{"op":"Find / Replace","args":[{"option":"Regex","string":"^.*$"},"This doesn't look like a Recycle Bin file to me ",true,false,true,false]},{"op":"Label","args":["Do Nothing"]}]```

## Recipe 19 - Identify Obfuscated Base64 with Regular Expression Highlighting

Less of a recipe and more of a technique. Using the 'highlight' function of the regular expression ingredient can clearly bring out where base64 data has been broken up with non-traditional base64 character set. Here the sequence '@<!' is used to obfuscate and disrupt automated encoding conversion. Looking further down the script, the sequence is substituted with 'A', which can then be inserted with a Find/Replace prior to the extraction. This continues for multiple rounds until a domain of interest is revealed (along with an executable prior).

Source: https://pastebin.com/TmJsB0Nv & https://twitter.com/pmelson/status/1167065236907659264

![Recipe 19_1](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_19_1.PNG)

![Recipe 19_2](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_19_2.PNG)

![Recipe 19_final](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_19_final.PNG)

### Recipe Details

```[{"op":"Find / Replace","args":[{"option":"Simple string","string":"@<!"},"A",true,false,true,false]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{20,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{50,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Find / Replace","args":[{"option":"Simple string","string":"@<!"},"A",true,false,true,false]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{50,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]}]```

## Recipe 20 - Using Yara rules with deobfuscated malicious scripts

Although not the most convienient way, CyberChef does provide the ability to run a yara rule over the output of a recipe. You could combine this by using the [multiple inputs](https://github.com/gchq/CyberChef/wiki/Multiple-Inputs) function to scan a larger number of files.

Source: https://twitter.com/ScumBots/status/1168528510681538560 & https://pastebin.com/r40SXe7V

![Recipe 20](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/recipe_20.PNG)

### Recipe Details

```[{"op":"Regular expression","args":["User defined","\\(.*\\);",true,false,false,false,false,false,"List matches"]},{"op":"Find / Replace","args":[{"option":"Regex","string":",|\\(|\\);"}," ",true,false,true,false]},{"op":"From Charcode","args":["Space",10]},{"op":"YARA Rules","args":["rule SuspiciousPowerShell {\n   meta:\n      description = \"Testing Yara on Cyberchef for Powershell\"\n   strings:\n      $a1 = \"[System.Reflection.Assembly]\" ascii\n      $a2 = \"IEX\" ascii nocase\n      $a3 = \"powershell.exe -w hidden -ep bypass -enc\" ascii\n   condition:\n      2 of them\n}",true,true,true,true]}]```



## Notes

Happy to add (and learn) more. Pull request or tweet to @mattnotmax!

Please include original source of text and recipe developer (if not yourself). For consistency in pasting into CyberChef I have found the best results are to export the function as compact JSON.


