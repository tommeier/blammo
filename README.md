# Blammo

*CHANGELOG from Blammo!*

Blammo is a tool which automatically generates a changelog by inspecting your git log.


## Introduction

TODO


## Quick Start

Install the gem:

    gem install blammo

Generate your changelog:

    blammo generate

Tweak your changelog (optional):

    vi changelog.yml

Render your changelog:

    blammo render




## TODO :

  * Update Blammo to run from class, not just through thor etc, update readme accordingly
  * Use Grit, for easier git processing
  * Add tilt templating for rendering out any method of display
  * Arg for environment to be used as prefix of file, eg: env_changelog.txt, can be different changelogs for each deploy
  * Ignore message patterns , array, eg : Array.new(self.ignore_message_patterns), /[/^ Some Message Tag To [IGNORE].*$/, /^[I]/]
  * Ignore Authors = Array.new(self.ignore_authors) = Array of author names to ignore (such as deploy bot)
  * Allow after/before hooks on generate, with blocks to iterate over captured commits
  * Update readme
  * Tighten specs
  * Cap deploy recipes, generator? Examples at the least... Is very different for each setup, depending on permissions.
