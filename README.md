# The Manual - Writing Super Collider Synthesisers For Sonic Pi

```
           _       _                 
     /\   | |     | |                
    /  \  | |_ __ | |__   __ _       
   / /\ \ | | '_ \| '_ \ / _` |      
  / ____ \| | |_) | | | | (_| |      
 /_/____\_\_| .__/|_| |_|\__,_|      
 |  ____|   | |                      
 | |__ ___  |_|_                     
 |  __/ _ \| '__|                    
 | | | (_) | |                       
 |_|__\___/|_|     _               _ 
 |  __ \          (_)             | |
 | |__) |_____   ___  _____      _| |
 |  _  // _ \ \ / / |/ _ \ \ /\ / / |
 | | \ \  __/\ V /| |  __/\ V  V /|_|
 |_|  \_\___| \_/ |_|\___| \_/\_/ (_)                                     

```

[Read It Now](https://gordonguthrie.github.io/TheManual/)

# Building Dockerised Sonic Pi

If you clone Sonic Pi alongside `TheManual/` in the directory `sonic-pi` you can build it inside the docker container we use to build the documentation.

# Dependencies

The build process requires that you download the Literate Compiler somewhere to your machine from https://github.com/gordonguthrie/literatecodereader/blob/main/literate_compiler/literate_compiler

You then need to edit the file `make_book.sh` to point to that

The process of generating the `pdf` file requires the installation of `wkhtmltopdf` from https://wkhtmltopdf.org/


# How documents are built

* the source files are under the directory `the_manual`
* the `literate_compiler` (invoked by the script `make_book.sh`) runs over the source and generates the markdown into the directory `docs/` - overwriting old content
* `Jekyll` coverts the markdown under `docs/` into the website at https://gordonguthrie.github.io/TheManual/
    * You can run Jeklly locally too using the [docker-dev](https://github.com/gordonguthrie/docker-dev/blob/main/README.md) repo
* the script `make_pdf.sh` uses `wkhtmltopdf` to generate a PDF of the website at https://gordonguthrie.github.io/TheManual/

# I am just making tweaks, correcting typos on existing pages

The dev process is:
* open a branch
* make changes
* push to github and open a pull request

Don't worry about the `literate_compiler` and jekyll build process that will be done after your changes have been merged.

# I am adding a new markdown page

The dev process is:
* open a branch
* make changes/add page
* edit `./docs/_data/contents.yml` to add the page
* edit the shell script `make_pdf.sh` to add the page
* push to github and open a pull request

Don't worry about the `literate_compiler` and jekyll build process that will be done after your changes have been merged.

# I am adding an image

Due to the build process, new images are ***NOT*** added under `the_manual/` but under `docs/images/chapterN`

# I am adding a new synthesiser page

The sources for the book are in the filed under `the_manual/` where edits and commits are made. If you wish to add a SuperCollider synthesiser please commit an `.scd` page with comments that are internally formatted with `markdown` (see the page `./the_manual/chapter5/second_synth.scd` for an example.

Also edit `./docs/_data/contents.yml` to add the page to the book and edit the shell script `make_pdf.sh` to add the page to it too.

But you need to check that your page transforms correctly.

The simple way is to install the `literate_compiler` (see the Section on Dependencies). If you commit your compiled docs to your branch you can inspect the output on https://github.com before you open your pull request.

The slightly more complex way is to also run `jekyll` locally and check it all works

You can do with easily by building this manual inside a docker container. The repo `docker-dev` is set up to make that easy:

* https://github.com/gordonguthrie/docker-dev/blob/main/README.md
