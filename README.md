G+ Blacklist
============

This is a Chrome extension which lets you define a blacklist of keywords.
Any posts in your Google+ stream that match to any of these keywords are filtered from the stream.


**This is a CoffeeScript port by Markus Birth.**
The original version of Ryad El-Dajani is [here](https://github.com/ryad-eldajani/gplusblacklist).


Compilation
-----------

To compile this extension, make sure you have installed the CoffeeScript compiler.

Then just run:

```
make
```

It will compile everything and the final extension ends up in the `build/` directory.



Installation
------------

To install the extension into your Chrome or Chromium browser, go to *Menu* → *Tools* → *Extensions*,
enable *Developer Mode* and load the `build/` directory using the **Load unpacked extension…** button.



Distribution
------------

If you want to create a Chrome Extension **.crx** package, just run:

```
make crx
```

It will generate an RSA key if needed and compile everything into a `gplusblacklist.crx`.
That file can then be distributed.
