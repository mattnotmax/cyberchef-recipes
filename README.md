# cyber-chef-recipes
A list of cyber-chef recipes 


## Scenario 1 - Extract base64, decompress and code beautify
ahack.bat
Sample: SHA256 cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54
https://www.hybrid-analysis.com/sample/cc9c6c38840af8573b8175f34e5c54078c1f3fb7c686a6dc49264a0812d56b54?environmentId=120

### Recipe

Regular_expression('User defined','[a-zA-Z0-9+/=]{30,}',true,true,false,false,false,false,'List matches')
From_Base64('A-Za-z0-9+/=',true)
Raw_Inflate(0,0,'Adaptive',false,false)
Generic_Code_Beautify()

## Scenario 2 - Invoke-Obfuscation
Acknowledgement NUT-95-52619.eml
Sample: SHA256 1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835
https://www.hybrid-analysis.com/sample/1240695523bbfe3ed450b64b80ed018bd890bfa81259118ca2ac534c2895c835?environmentId=120


### Recipe

Find_/_Replace({'option':'Regex','string':'\\^|\\\\|-|_|\\/|\\s'},'',true,false,true,false)
Reverse('Character')
Generic_Code_Beautify()
Find_/_Replace({'option':'Simple string','string':'http:'},'http://',true,false,true,false)

