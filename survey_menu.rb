require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
I18n.enforce_available_locales = false
require "date"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  today = Date.today
  puts "\n"
  puts "*" * 50
  puts "  Welcome to Cindy's Survey Company #{today}"
  puts "*" * 50
  puts "\n"
  main_menu
end

def main_menu
  loop do
    puts "\nMAIN MENU"
    puts "Enter 'D' if you are a designing or editing a survey"
    puts "Enter 'T' if you are taking a survey"
    puts "Enter 'M' to return to this menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    case option
    when 'D'
      designer_menu
    when 'T'
      taker_menu
    when 'M'
    when 'X'
      exit_program
    else
      puts "\nInvalid option selected, try again"
    end
  end
end

def designer_menu
  puts "\nPlease enter your name (25 character maximum)"
  input_name = gets.chomp.titleize
  designer_array = SurveyDesigner.where("name = ?", input_name)
  if designer_array.empty?
    @current_designer = SurveyDesigner.create(:name => input_name)
  else
    @current_designer = designer_array.first
  end
  current_survey = nil
  current_question = nil
  option = nil
  while option != 'M' && option != 'X'
    puts "\nDESIGNER MENU"
    puts "Enter 'S' to go to the survey menu"
    puts "Enter 'Q' to go to the question menu"
    puts "Enter 'R' to go to the response menu"
    puts "Enter 'M' to go to the main menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    case option
    when 'S'
      survey_menu
    when 'Q'
      question_menu(current_survey)
    when 'R'
      response_menu(current_question)
    when 'M'
    when 'X'
      exit_program
    else
      puts "\nInvalid option entered, try again"
    end
  end
end

def survey_menu
  current_survey = nil
  option = nil
  while option != "B" && option != 'X'
    puts "\nSURVEY MENU"
    puts "Enter 'C' to create a new survey"
    puts "Enter 'E' to view or edit an existing survey"
    puts "Enter 'L' to list all surveys in the database"
    puts "Enter 'Q' to list all of the questions for a survey"
    puts "Enter 'D' to delete a survey"
    puts "Enter 'B' to go back to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    case option
    when 'C'
      create_survey
    when 'E'
      edit_survey
    when 'L'
      list_all_surveys
    when 'Q'
      current_survey = get_survey_from_name
      list_questions_for_survey(current_survey)
    when 'D'
      delete_survey
    when 'B'
    when 'X'
      exit_program
    else
      puts "\nInvalid option entered, try again"
    end
  end
end

def create_survey
  puts "\nCREATE SURVEY"
  puts "Enter a name for the new survey (25 character maximum)"
  input_name = gets.chomp.titleize
  new_survey = Survey.new(:name => input_name, :date_created => @today, :survey_designer_id => @current_designer.id)
  if new_survey.save
    create_question(new_survey)
  else
    puts "Please fix these errors:"
    new_survey.errors.full_messages.each do |message|
      puts "#{message}"
    end
  end
end

def edit_survey
  option = nil
  while option != "B" && option != 'X'
    puts "\nEDIT SURVEY"
    puts "Enter 'N' to change the name of the survey"
    puts "Enter 'Q' to go to the question menu (to add, edit or delete questions)"
    puts "Enter 'B' to go back to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    case option
    when 'N'
      current_survey = get_survey_from_name
      if !current_survey.nil?
        change_survey_name(current_survey)
      else
        option = "B"
      end
    when 'Q'
      current_survey = get_survey_from_name
      if !current_survey.nil?
        question_menu(current_survey)
      else
        option = "B"
      end
    when 'B'
    when 'X'
      exit_program
    else
      "\nInvalid option entered, try again"
    end
  end
end

def get_survey_from_name
  current_survey = nil
  puts "\nEnter the name of the survey"
  current_name = gets.chomp.titleize
  survey_array = Survey.where("name = ?", current_name)
  if survey_array.empty?
    puts "\nThe survey #{current_name} is not in the database"
  else
    current_survey = survey_array.first
  end
  current_survey
end

def change_survey_name(current_survey)
  puts "\nCHANGE SURVEY NAME"
  puts "Enter the new survey name (25 character maximum)\n"
  new_name = gets.chomp.titleize
  if !current_survey.update(:name=>new_name)
    puts "Please fix these errors:"
    current_survey.errors.full_messages.each do |message|
      puts "#{message}"
    end
  end
end

def list_all_surveys
  puts "\nLIST ALL SURVEYS\n"
  all_surveys = Survey.all.order(:name)
  if !all_surveys.empty?
    all_surveys.each_with_index do |survey, index|
      puts "#{index+1}. #{survey.name}, #{survey.questions.count} questions"
    end
    puts "\n"
  else
    puts "\nThere are no surveys in the database\n"
  end
end

def list_questions_for_survey(current_survey)
  puts "\nLIST QUESTIONS FOR A SURVEY"
  if !current_survey.nil?
    puts "\nFor survey #{current_survey.name}, the questions are"
    question_array = current_survey.questions.order(:id)
    if !question_array.empty?
      question_array.each_with_index do |question, index|
        puts "#{index+1}. #{question.question_text}"
      end
    else
      puts "There are no questions for the survey\n"
    end
    puts "\n"
  end
  question_array
end

def delete_survey
  puts "\nDELETE SURVEY"
  current_survey = get_survey_from_name
  if !current_survey.nil?
    puts "\nAre you sure you want to delete this survey from the database?"
    puts "Enter 'Y' or 'YES' to delete (any other key will skip the deletion)"
    response = gets.chomp.slice(0,1).upcase
    if response == "Y"
      delete_all_questions(current_survey)
      current_survey.destroy
    else
      puts "\nNothing was deleted"
    end
  end
end

def question_menu(current_survey)
  current_question = nil
  option = nil
  while option != "B" && option != 'X'
    puts "\nQUESTION MENU"
    puts "Enter 'C' to create a question"
    puts "Enter 'E' to edit the text of a question"
    puts "Enter 'L' to list all of the responses for a question"
    puts "Enter 'D' to delete a question"
    puts "Enter 'R' to go to the response menu (to add, edit or delete responses)"
    puts "Enter 'B' to go back to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    if current_survey.nil? && option != "B" && option != "X"
      current_survey = get_survey_from_name
    elsif option == "X"
      exit_program
    end
    if option != "B" && !current_survey.nil?
      case option
      when 'C'
        create_question(current_survey)
      when 'E'
        edit_question_text(current_survey)
      when 'L'
        list_responses_for_question(current_survey)
      when 'D'
        delete_question(current_survey)
      when 'R'
        response_menu(current_question)
      else
        "\nInvalid option entered, try again"
      end
    end
  end
end

def create_question(current_survey)
  option = nil
  puts "\nCREATE QUESTION"
  while option != "B" && option != "X"
    puts "Enter text for the question (100 character maximum)"
    input_text = gets.chomp
    new_question = Question.new(:question_text => input_text, :survey_id => current_survey.id)
    if new_question.save
      create_responses(new_question)
    else
     puts "Please fix these errors:"
      new_question.errors.full_messages.each do |message|
        puts "#{message}"
      end
    end
    puts "Enter 'B' to stop adding questions to the survey #{current_survey.name} and go back to the main menu"
    puts "Enter 'X' to enter the program"
    puts "Enter any other character to continue adding questions to the survey #{current_survey.name}"
    option = gets.chomp.upcase
  end
end

def edit_question_text(current_survey)
  question_array = list_questions_for_survey(current_survey)
  if !question_array.empty?
    puts "\nSelect the index of the question whose text you'd like to change"
    question_index = gets.chomp.to_i
    if question_index == 0 || question_index > question_array.length
      puts "\nInvalid index selected, try again"
    else
      current_question = question_array[question_index-1]
      puts "\nEnter the new text for the question"
      input_text = gets.chomp
      if !current_question.update(:question_text=>input_text)
        puts "Please fix these errors:"
        current_survey.errors.full_messages.each do |message|
          puts "#{message}"
        end
      end
    end
  end
end

def list_responses_for_question(current_survey)
end

def delete_all_questions(current_survey)
  if !current_survey.questions.empty?
    current_survey.questions.each do |question|
      delete_all_responses(question)
      question.delete
    end
  end
end

def delete_question(current_survey)
  current_question = nil
  puts "\nDELETE QUESTION"
  question_array = list_questions_for_survey(current_survey)
  puts "\nSelect the index of the question you'd like to delete"
  question_index = gets.chomp.to_i
  if !question_array.empty?
    if question_index == 0 || question_index > question_array.length
      puts "\nInvalid index selected, try again"
    else
      current_question = question_array[question_index-1]
    end
    if !current_question.nil?
      puts "\nAre you sure you want to delete this survey from the database?"
      puts "Enter 'Y' or 'YES' to delete (any other key will skip the deletion)"
      response = gets.chomp.slice(0,1).upcase
      if response == "Y"
        delete_all_responses(current_question)
        current_question.destroy
      else
        puts "\nNothing was deleted"
      end
    else
      puts "\nAn invalid question was selected, try again"
    end
  end
end

def response_menu(current_question)
end

def create_responses(current_question)
end

def delete_all_responses(current_question)
end

def exit_program
  puts "\nThanks for visiting Cindy's Survey Company\n\n"
  exit
end

welcome
