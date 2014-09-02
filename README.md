survey\_AR
====================

## README for the Survey application written in Ruby using Active Record

* Author: Cindy Ward <cindyward@yahoo.com>
* Date created: August 31, 2014
* Last modification date: September 2, 2014
* Created for:  Epicodus, Summer 2014 session

## Included; written by author:
* ./README.md (this file)
* ./Gemfile (list of gems to be installed by bundler; please see below for more information)
* ./Gemfile.lock (list of gems and versions actually installed by bundler; please see below for more information)
* ./LICENSE.md (using the "Unlicense" template)
* ./Rakefile (configuration information used by 'rake' utility)
* ./survey_menu.rb (main application file)
* ./db/config.yml (database configuration file showing the names of the development and test databases)
* ./db/schema.rb (database schema)
* ./db/migrate/*.rb (database migrations, which show the development of the database step-by-step. These are stored in the database as an additional table. The names are preceded by time stamps so they vary)
* ./lib/chosen\_response.rb (the Ruby implementation of the ChosenResponse class)
* ./lib/question.rb (the Ruby implementation of the Question class)
* ./lib/response.rb (the Ruby implementation of the Response class)
* ./lib/survey\_designer.rb (the Ruby implementation of the SurveyDesigner class)
* ./lib/survey\_taker.rb (the Ruby implementation of the SurveyTaker class)
* ./lib/survey.rb (the Ruby implementation of the Survey class)
* ./lib/taken\_survey.rb (the Ruby implementation of the TakenSurvey class)
* ./spec/chosen\_response\_spec.rb (the Ruby implementation of the ChosenResponse class)
* ./spec/question\_spec.rb (the Ruby implementation of the Question class)
* ./spec/response\_spec.rb (the Ruby implementation of the Response class)
* ./spec/spec\_helper.rb (utility code for opening database, loading required files, etc.)
* ./spec/survey\_designer\_spec.rb (the Ruby implementation of the SurveyDesigner class)
* ./spec/survey\_spec.rb (the Ruby implementation of the Survey class)
* ./spec/survey\_taker\_spec.rb (the Ruby implementation of the SurveyTaker class)
* ./spec/taken\_survey\_spec.rb (the Ruby implementation of the TakenSurvey class)

## Requirements for execution:
* [The Ruby language interpreter](https://www.ruby-lang.org/en/downloads/) must be installed. Please use version 2.1.2.

* [git clone](http://github.com/) the image available at http://github.com/cindyward1/survey_AR, which will create a survey\_AR directory with db, lib and spec subdirectories.

* [Homebrew](http://brew.sh/) is a package installer for Apple computers. To install homebrew, enter the following at a terminal application prompt **$: ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"**

* [PostgreSQL](http://http://www.postgresql.org/) is a SQL database package. To install PostgreSQL on an Apple computer, enter the following at a terminal application prompt **$: brew install postgres** . To configure PostgreSQL, enter the following commands at a terminal application prompt $:
 * **$: echo "export PGDATA=/usr/local/var/postgres" >> ~/.bash\_profile**
 * **$: echo "export PGHOST=/tmp" >> ~/.bash\_profile**
 * **$: source ~/.bash\_profile**
* To start the PostgreSQL server, enter the following at a terminal application prompt **$: postgres** . It is necessary to leave the window open for the server to continue to run. To create a database with the user's login name, enter the following at a teriminal application prompt **$: createdb $USER**

* [Bundler](http://bundler.io) tracks and installs the exact gems and versions that are needed. To install Bundler, enter the following at a terminal application prompt **$: gem install bundler**
* The following gems from http://rubygems.org will be automatically installed by entering the following at a terminal application prompt **$: bundle install**
 * [activerecord](https://rubygems.org/gems/activerecord) maps database tables to Ruby classes
 * [pg](https://rubygems.org/gems/pg) implements the Ruby interface to the PostgreSQL database
 * [rake](https://rubygems.org/gems/rake) controls the generation of executables and other non-source files from a program's source files
 * [active\_record\_migrations](https://rubygems.org/gems/active\_record\_migrations) allows the use of Active Record migrations in non-Rails projects
 * [titleize](bygems.org/gems/titleize) adds String#titleize for creating properly capitalized titles (used for survey designer, survey taker, and survey names)
 * (test configuration only) [rspec](https://rubygems.org/gems/rspec) is a testing tool for the Ruby language.
 * (test configuration only) [shoulda-matchers](http://robots.thoughtbot.com/shoulda-matchers-2-6-0) "makes tests easy on the fingers and eyes" by simplifying the expression of rspec test conditions to be met.

* To create the database, cd to (clone location)/survey\_AR and enter enter the following at a terminal application prompt **$: rake db:create** followed by **$: rake db:schema:load**

* To run the application, cd to (clone location)/survey\_AR and enter the following at a terminal application prompt **$: ruby survey.rb**
* You can also test a non-interactive version of the methods against their test cases found in (clone location)/survey\_AR/spec/\*.rb using rspec (see gem reference above). Please use version 3.1.1. If you wish to do this, you must first cd to (clone location)/survey\_AR and enter the following at a terminal application **$: rake db:test:prepare** . This will prepare the test version of the database for use. Then to run rspec, cd to (clone location)/survey\_AR and enter the following string at a terminal application **$: rspec** (This command will automatically execute any .rb file it finds in ./spec/.)

* Please note that this repository has only been tested with [Google Chrome browser](http://www.google.com/intl/en/chrome/browser) version 36.0.1985.125 on an iMac running [Apple](http://www.apple.com) OS X version 10.9.4 (Mavericks). Execution on any other computing platform, browser or operating system is at the user's risk.

## Description:
This Ruby application implements a character user interface to a survey application. The user interface is divided into two parts: the actions a survey designer performs to create surveys and see statistics about the surveys taken, and the actions a survey taker performs to take the survey by recording responses to the survey questions.
### The survey designer is able to:
* Create a new survey to get people's opinion on important matters.
* Add questions to the survey to find out what people think about them.
* Add possible responses to each question to structure people's opinions into discrete choices that they must choose among. All questions are multiple-choice with only 1 choice to be selected
* View the number and percentage of respondents who picked each possible response to each question to see the results of the survey.

### The survey taker is able to:
* Choose what survey to take to give the surveyor their opinion.
* View one question at a time to keep from getting distracted by other questions.
* Choose among the possible responses for each question to actually input their opinion.
* Take a given survey only once and be informed of the date it was previously taken.

##Thanks:
* To my wonderful husband Steve Ward for his support and his incredible patience, and for repeatedly testing this program for me.
* To Dustin Brown for his encouragement.
