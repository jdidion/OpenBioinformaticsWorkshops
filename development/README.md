# Developing Lessons

Lessons consist of some or all of the following:

* Text documents
    * Syllabus
    * Cheat sheets
    * Tutorials/guides
    * Exercises
    * Scripts
* Slides
* Videos
* Data sets
* Results of running the exercises
* Docker, AWS, or other images with required software

# Text Documents

All OBW text documents should be written in markdown; ideally only using the syntax that is part of the [CommonMark](http://commonmark.org/) spec. It is perfectly acceptable to make "prettified" versions of these documents (e.g. with stylesheets), but scripts should be provided to generate those versions from the source documents.

We expect that there will be cases where more sophisticated documents are needed than what markdown supports. For example, dynamic HTML is necessary to have exercises where the solution is available but hidden from the user until they choose to reveal it. In these cases, we will provide templates.

# Slides

Slides too should be created in markdown, although special syntax is required. Currently, [Remark.js](https://remarkjs.com) looks like the best option. [Remark boilerplate](https://github.com/brenopolanski/remark-boilerplate) is a good option for automatically rendering slides and publishing to GitHub. There is also [Xaringan](https://github.com/yihui/xaringan) for generating Remark.js slides from Rmarkdown. Third party [renderers](https://remarkjs.com/remarkise) and [editors](http://platon.io/) also exist. [DeckTape](https://github.com/astefanutti/decktape) can be used to export slides to PDF. It is also acceptable to provide Google Doc slides (under a CC0 license). Please ensure that all media (images, videos, etc.) used in slides is licensed for reuse. Furthermore, it should be noted whether the license is compatible with for-profit use (e.g. in a workshop run by a for-profit company).

# Videos

Videos may be sourced from existing content, or they may be created specifically for OBW. For sourced videos, ensure that the license allows for re-use, and note whether commercial reuse is allowed. Videos created specifically for OBW must be donated under a CC0 license. An open question for such videos is where they are to be hosted. The two most likely options are YouTube (e.g. via an OBW account or channel) and a file sharing site (e.g. Dropbox).

# Data sets

Example data sets must meet the following criteria to be included in one of our workshops:

1. Either generated from non-human organisms, or completely de-identified
2. Available in a public data repository (e.g. SRA). It is also acceptable to include data associated with a published study that is available from a public web site (e.g. a university web page), as long as it is unambiguously clear that the data is available for unrestricted reuse. Data sets may also be donated to OBW under a CC0 license, although there remains the open question about where the data is to be hosted.
3. No larger than it needs to be in order to illustrate the desired point. The most important consideration is time - how long it takes to download the files, and how long it takes to process them. Ideally, processing time should be kept to a minute or less on a modern laptop. It is fine to deviate from this when it's really necessary, but the lesson should work around the longer processing time, e.g. start a job running, go on to teach the next part of the lesson, then come back to the job once it's finished.
4. Be in a "standard" format, where "standard" is in quotes because often times in bioinformatics standards are *de facto* rather than actually ratified by some official body. Data sets that require conversion from some obscure format in order to be usable should be avoided. Additionally, software that uses its own invented input and/or output format instead of "standard" formats should be avoided, even if it is arguably better than similar software that uses "standard" formats.

# Software/Machine Images

Our workshops use software images to simplify setup. The goal is for all of the software used in a workshop to be setup using a small number of downloads or shell commands. There are a few ways to do this:

* The participants all log into a cloud environment such as AWS. In this case, the workshop software is packaged as a Docker or AWS image that can be deployed to the machine instance(s) ahead of time.
* The participants all work on their own computers. In this case, a Docker image would still suffice.
* An alternative that may require less upfront work is to use a separate Docker image for each piece of software, many of which are already provided (e.g. http://bioboxes.org/). However, this would require a more complicated installation process for the participants.

We recommend providing a single Docker image that contains all required software, and our default workshop setup guide will reflect this. If you develop a workshop and choose to deviate from this, please make sure to provide a detailed setup guide.

# Goals versus Reality

The workshop materials that are currently available here are in PowerPoint format. The goal is to transition these to MarkDown as described above, but this will take time. Any help is greaty appreciated!
