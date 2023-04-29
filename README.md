# neovim-chatgpt-plugin

This is a chatgpt plugin for neovim where it will write tests, documentation and suggests whether bugs exists in the code.


Add this plugin to the neovim with the help of neovim plugin manager configured.


To add this plugin to Astrovim,

just copy the file from misc and add it to the lua folder in Astrovim.


Add your OpenAI api key to the sample env file and rename it to '.env' file and then start using this ChatGPTMagic command.



Scope:

This works only for python files currently and helps with the comments to be documented for the functions in the current file.

you can use the command 
`:ChatGPTMagic` and it will output the comments to be added to those python functions in the current file.

More changes are upcoming to help with tests and finding bugs with diagnostics and much more helpful stuff like the output from chatGPT be processed and copied to a tab or the same file.
