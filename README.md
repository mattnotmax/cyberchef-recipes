# CyberChef Recipes

A list of CyberChef recipes 

For background see Twitter #cyberchef or https://bitofhex.com/2018/05/29/cyberchef/

Full credit to @GCHQ for producing the tool. See: https://gchq.github.io/CyberChef/

[Scenario 1: Extract base64, raw inflate & beautify](#scenario-1---extract-base64-raw-inflate-and-code-beautify)

[Scenario 2: Invoke Obfuscation](#scenario-2---invoke-obfuscation)

[Scenario 3: From CharCode](#scenario-3---from-charcode)

[Scenario 4: Group Policy Preference Password Decryption](#scenario-4---group-policy-preference-passwords)

[Scenario 5: Using Loops and Labels](#scenario-5---using-loops--labels)

[Scenario 6: Google ei Timestamps](#scenario-6---google-ei-timestamp)

[Scenario 7: Multi-stage COM scriplet to x86 assembly](#scenario-7---com-scriplet-to-disassembled-x86-assembly)

[Scenario 8: - Extract hexadecimal, convert to hexdump for embedded PE file](#scenario-8---extract-hexadecimal-convert-to-hexdump-for-embedded-pe-file)

[Scenario 9 - Reverse strings, character substitution, from base64](#scenario-9---reverse-strings-character-substitution-from-base64)

[Scenario 10 - Extract object from Squid proxy cache](#scenario-10---extract-object-from-squid-proxy-cache)

[Scenario 11 - Extract GPS Coordinates to Google Maps URLs](#scenario-11---extract-gps-coordinates-to-google-maps-urls)

[Scenario 12 - Big Number Processing](#scenario-12---big-number-processing)

[Other Misc Recipes](#other-misc-recipes-found-on-twitter)


## Scenario 1 - Extract base64, raw inflate and code beautify

A very common scenario: extract Base64, inflate, beautify the code. You may need to then do further processing or dynamic analysis depending on the next stage.

Filename: ahack.bat

Zipped File: cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54_183SnuOIVa.bin.gz

Sample: SHA256 cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54

https://www.hybrid-analysis.com/sample/cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54?environmentId=120

### Recipe (compact JSON)

```[{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Adaptive",false,false]},{"op":"Generic Code Beautify","args":[]}]```

![Scenario_1](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_1.PNG)


## Scenario 2 - Invoke-Obfuscation

CyberChef won't be able to handle all types of Invoke-Obfuscation, but here is one that can be decoded.

Filename: Acknowledgement NUT-95-52619.eml

Zipped File: 1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835.bin.gz

Sample: SHA256 1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835

https://www.hybrid-analysis.com/sample/1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835?environmentId=120


### Recipe (compact JSON)

```[{"op":"Find / Replace","args":[{"option":"Regex","string":"\\^|\\\\|-|_|\\/|\\s"},"",true,false,true,false]},{"op":"Reverse","args":["Character"]},{"op":"Generic Code Beautify","args":[]},{"op":"Find / Replace","args":[{"option":"Simple string","string":"http:"},"http://",true,false,true,false]},{"op":"Extract URLs","args":[false]},{"op":"Defang URL","args":[true,true,true,"Valid domains and full URLs"]}]```

![Scenario_2](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_2.PNG)

## Scenario 3 - From CharCode

Malware and scripts often use Charcode to represent characters in order to evade from AV and EDR solutions. CyberChef eats this up.

Filename: 3431818-f71f60d10b1cbe034dc1be242c6efa5b9812f3c6.zip

Source: https://gist.github.com/jonmarkgo/3431818

### Recipe (compact JSON)

```[{"op":"Regular expression","args":["User defined","([0-9]{2,3}(,\\s|))+",true,true,false,false,false,false,"List matches"]},{"op":"From Charcode","args":["Comma",10]},{"op":"Regular expression","args":["User defined","([0-9]{2,3}(,\\s|))+",true,true,false,false,false,false,"List matches"]},{"op":"From Charcode","args":["Space",10]}]```

![Scenario_3](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_3.PNG)

## Scenario 4 - Group Policy Preference passwords

When a new GPP is created, there’s an associated XML file created in SYSVOL with the relevant configuration data and if there is a password provided, it is AES-256 bit encrypted. Microsoft published the AES Key, which can be used to decrypt passwords store in:  \\<DOMAIN>\SYSVOL\<DOMAIN>\Policies\

Credit: @cyb3rops

Source 1: https://twitter.com/cyb3rops/status/1036642978167758848

Source 2: https://adsecurity.org/?p=2288

### Recipe (compact JSON)

```[{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hex","args":["None"]},{"op":"AES Decrypt","args":[{"option":"Hex","string":"4e9906e8fcb66cc9faf49310620ffee8f496e806cc057990209b09a433b66c1b"},{"option":"Hex","string":""},"CBC","Hex","Raw",{"option":"Hex","string":""}]},{"op":"Decode text","args":["UTF16LE (1200)"]}]```

![Scenario_4](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_4.PNG)

## Scenario 5 - Using loops & labels

CyberChef can use labels to identify parts of the recipe and then loop back to perform operations multiple times. In this examples, there are 29 rounds of Base64 encoding which are extracted and decoded.

Credit: @pmelson

Source File: hmCPDnHs.txt

Source 1: https://pastebin.com/hmCPDnHs

Source 2: https://twitter.com/pmelson/status/1078776229996752896

### Recipe (compact JSON)

```[{"op":"Label","args":["top"]},{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Adaptive",false,false]},{"op":"Jump","args":["top",28]},{"op":"Generic Code Beautify","args":[]}]```

![Scenario_5](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_5.PNG)


## Scenario 6 - Google ei timestamp

Google uses its own timestamp, I call ei time, which it embeds in the URL.

Source: https://bitofhex.com/2018/05/29/cyberchef/

### Recipe (compact JSON)

```[{"op":"From Base64","args":["A-Za-z0-9-_=",true]},{"op":"To Hex","args":["None"]},{"op":"Take bytes","args":[0,8,false]},{"op":"Swap endianness","args":["Hex",4,true]},{"op":"From Base","args":[16]},{"op":"From UNIX Timestamp","args":["Seconds (s)"]}]```

![Scenario_6](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_6.PNG)

## Scenario 7 - COM scriplet to disassembled x86 assembly

This is an eleven stage decoded COM scriplet that uses Base64, Gunzip, RegEx, and Disassemble x86 instructions.

Credit: @JohnLaTwC

Filename: 41a6e22ec6e60af43269f4eb1eb758c91cf746e0772cecd4a69bb5f6faac3578.txt

Source 1: https://gist.githubusercontent.com/JohnLaTwC/aae3b64006956e8cb7e0127452b5778f/raw/f1b23c84c654b1ea60f0e57a860c74385915c9e2/43cbbbf93121f3644ba26a273ebdb54d8827b25eb9c754d3631be395f06d8cff

Source 2: https://twitter.com/JohnLaTwC/status/1062419803304976385

### Recipe (compact JSON)

```[{"op":"Regular expression","args":["","[A-Za-z0-9=/]{40,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Remove null bytes","args":[]},{"op":"Regular expression","args":["User defined","[A-Za-z0-9+/=]{40,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Gunzip","args":[]},{"op":"Regular expression","args":["User defined","[A-Za-z0-9+/=]{40,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hex","args":["Space"]},{"op":"Remove whitespace","args":[true,true,true,true,true,false]},{"op":"Disassemble x86","args":["32","Full x86 architecture",16,0,true,true]}]```

![Scenario_7](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_7.png)

## Scenario 8 - Extract hexadecimal, convert to hexdump for embedded PE file

This file has an embedded PE file (SHA 256: 26fac1d4ea12cdceac0d64ab9694d0582104b3c84d7940a4796c1df797d0fdc2, R5Sez8PH.exe, VT: 54/70). Using CyberChef, we can regex hexadecimal and the convert to a more easily viewable hexdump.

Source 1: https://pastebin.com/R5Sez8PH

Source 2: https://twitter.com/ScumBots/status/1081949877272276992

### Recipe (compact JSON)

```[{"op":"Regular expression","args":["User defined","[a-fA-F0-9]{200,}",true,true,false,false,false,false,"List matches"]},{"op":"From Hex","args":["Auto"]},{"op":"To Hexdump","args":[16,false,false]}]```

![Scenario_8](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/Scenario_8.png)

## Scenario 9 - Reverse strings, character substitution, from base64

A blob of base64 with some minor bytes to be substituted. Original decoding done by @pmelson in Python and converted to CyberChef.

Credit: @pmelson

Source 1: https://pastebin.com/RtjrweYF

Source 2: https://twitter.com/pmelson/status/1076893022758100998

### Recipe (compact JSON)

```[{"op":"Reverse","args":["Character"]},{"op":"Find / Replace","args":[{"option":"Regex","string":"%"},"A",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Regex","string":"×"},"T",true,false,false,false]},{"op":"Find / Replace","args":[{"option":"Simple string","string":"÷"},"V",true,false,false,false]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hexdump","args":[16,false,false]}]```

![Scenario_9](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_9.png)


## Scenario 10 - Extract object from Squid proxy cache

Don't manually carve out your Squid cache objects. Simply upload the file to CyberChef. This recipe will search for the magic bytes 0x0D0A0D0A, extract everything after. It then gzip decompresses the object for download.

Source: 00000915 (output should be TrueCrypt_Setup_7.1a.exe with SHA256 e95eca399dfe95500c4de569efc4cc77b75e2b66a864d467df37733ec06a0ff2)

### Recipe (compact JSON)

```[{"op":"To Hex","args":["None"]},{"op":"Regular expression","args":["User defined","(?<=0D0A0D0A).*$",true,false,false,false,false,false,"List matches"]},{"op":"From Hex","args":["Auto"]},{"op":"Gunzip","args":[]}]```

![Scenario_10](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_10.png)

## Scenario 11 - Extract GPS Coordinates to Google Maps URLs

If you need to quickly triage where a photo was taken and you're lucky enought to have embedded GPS latitude and longitudes then use this recipe to quickly make a usable Google Maps URL to identify the location.

### Recipe (compact JSON)

```[{"op":"Extract EXIF","args":[]},{"op":"Regular expression","args":["User defined","((?<=GPSLatitude:).*$)|((?<=GPSLongitude: ).*$)",true,true,false,false,false,false,"List matches"]},{"op":"Find / Replace","args":[{"option":"Extended (\\n, \\t, \\x...)","string":"\\n"},",",true,false,true,false]},{"op":"Find / Replace","args":[{"option":"Simple string","string":" "},"https://maps.google.com/?q=",true,false,true,false]}]```

![Scenario_11](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_11.png)

## Scenario 12 - Big Number Processing

CyberChef can handle massive numbers. Here we can use a simple recipe to change a 38-digit X509SerialNumber to its hexadecimal equivalent X.509 certificate serial number. Then we can regex the hexadecimal and insert a colon to transform it to the correct format.

Credit: @QW5kcmV3

Source: https://twitter.com/QW5kcmV3/status/949437437473968128

### Recipe (compact JSON)

```[{"op":"To Base","args":[16]},{"op":"Regular expression","args":["User defined","[a-f0-9]{2,2}",true,true,false,false,false,false,"List matches"]},{"op":"Find / Replace","args":[{"option":"Extended (\\n, \\t, \\x...)","string":"\\n"},":",true,false,true,false]}]```

![Scenario_12](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_12.png)


## Other misc recipes found on Twitter

Example of loops over Base64: (Credit: @QW5kcmV3)
https://twitter.com/QW5kcmV3/status/1079095274776289280




## Notes

Happy to add (and learn) more. 

Please include original source of text and recipe developer (if not yourself). For consistency in pasting into CyberChef I have found the best results are to export the function as compact JSON.


