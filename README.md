# CyberChef Recipes
A list of cyber-chef recipes 

For background see Twitter #cyberchef or https://bitofhex.com/2018/05/29/cyberchef/

Full credit to @GCHQ for producing the tool. See: https://gchq.github.io/CyberChef/


## Scenario 1 - Extract base64, decompress and code beautify

Filename: ahack.bat

Sample: SHA256 cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54

https://www.hybrid-analysis.com/sample/cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54?environmentId=120

### Recipe (compact JSON)

[{"op":"Regular expression","args":["User defined","[a-zA-Z0-9+/=]{30,}",true,true,false,false,false,false,"List matches"]},{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"Raw Inflate","args":[0,0,"Adaptive",false,false]},{"op":"Generic Code Beautify","args":[]}]

![Scenario_1](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_1.PNG)


## Scenario 2 - Invoke-Obfuscation

Filename: Acknowledgement NUT-95-52619.eml

Sample: SHA256 1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835

https://www.hybrid-analysis.com/sample/1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835?environmentId=120


### Recipe (compact JSON)

[{"op":"Find / Replace","args":[{"option":"Regex","string":"\\^|\\\\|-|_|\\/|\\s"},"",true,false,true,false]},{"op":"Reverse","args":["Character"]},{"op":"Generic Code Beautify","args":[]},{"op":"Find / Replace","args":[{"option":"Simple string","string":"http:"},"http://",true,false,true,false]}]

![Scenario_2](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_2.PNG)

## Scenario 3 - From CharCode

Source: https://gist.github.com/jonmarkgo/3431818

### Recipe (compact JSON)

[{"op":"Regular expression","args":["User defined","([0-9]{2,3}(,\\s|))+",true,true,false,false,false,false,"List matches"]},{"op":"From Charcode","args":["Comma",10]},{"op":"Regular expression","args":["User defined","([0-9]{2,3}(,\\s|))+",true,true,false,false,false,false,"List matches"]},{"op":"From Charcode","args":["Space",10]}]

![Scenario_3](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_3.PNG)

## Scenario 4 - Group Policy Preference passwords

Credit: @cyb3rops

Source 1: https://twitter.com/cyb3rops/status/1036642978167758848

Source 2: https://adsecurity.org/?p=2288

### Recipe (compact JSON)

[{"op":"From Base64","args":["A-Za-z0-9+/=",true]},{"op":"To Hex","args":["None"]},{"op":"AES Decrypt","args":[{"option":"Hex","string":"4e9906e8fcb66cc9faf49310620ffee8f496e806cc057990209b09a433b66c1b"},{"option":"Hex","string":""},"CBC","Hex","Raw",{"option":"Hex","string":""}]},{"op":"Decode text","args":["UTF16LE (1200)"]}]

![Scenario_4](https://github.com/mattnotmax/cyber-chef-recipes/blob/master/screenshots/scenario_4.PNG)


## Other misc recipes found on Twitter

Example of loops over Base64: (Credit: @QW5kcmV3)
https://twitter.com/QW5kcmV3/status/1079095274776289280

Example of multi-stage obfuscation (Credit: @JohnLaTwC)
https://twitter.com/JohnLaTwC/status/1062419803304976385



## Notes

Happy to add (and learn) more. 

Please include original source of text and recipe developer (if not yourself). For consistency in pasting into CyberChef I have found the best results are to export the function as compact JSON.


