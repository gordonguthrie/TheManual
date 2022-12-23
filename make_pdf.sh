#!/bin/bash
wkhtmltopdf --javascript-delay 400 \
http://localhost:5000/index.html
the_manual.pdf