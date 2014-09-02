require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
I18n.enforce_available_locales = false
require "date"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  @today = Date.today
  puts "\n"
  puts "*" * 50
  puts "  Welcome to Cindy's Survey Company #{@today}"
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
  while option != "P" && option != 'X'
    puts "\nSURVEY MENU"
    puts "Enter 'C' to create a new survey"
    puts "Enter 'L' to list all surveys in the database"
    puts "Enter 'Q' to list all of the questions for a survey"
    puts "Enter 'E' to view or edit an existing survey (including list of questions)"
    puts "Enter 'D' to delete a survey"
    puts "Enter 'P' to go to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    case option
    when 'C'
      create_survey
    when 'L'
      list_all_surveys
    when 'Q'
      list_questions_for_survey(current_survey)
    when 'E'
      edit_survey
    when 'D'
      delete_survey
    when 'P'
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

def list_all_surveys
  puts "\nLIST ALL SURVEYS\n"
  all_surveys = Survey.all.order(:name)
  if !all_surveys.empty?
    all_surveys.each_with_index do |survey, index|
      puts "#{index+1}. #{survey.name}, #{survey.questions.count} question(s)"
    end
    puts "\n"
  else
    puts "\nThere are no surveys in the database\n"
  end
  all_surveys
end

def list_questions_for_survey(current_survey)
  question_array = []
  puts "\nLIST QUESTIONS FOR A SURVEY"
  if current_survey.nil?
    current_survey = get_survey_from_name
  end
  if !current_survey.nil?
    puts "\nFor survey #{current_survey.name}, the questions are"
    question_array = current_survey.questions.order(:id)
    if !question_array.empty?
      question_array.each_with_index do |question, index|
        puts "#{index+1}. #{question.question_text}"
      end
    else
      puts "There are no questions for survey #{current_survey.name} in the database\n"
    end
    puts "\n"
  end
  question_array
end

def edit_survey
  option = nil
  while option != "P" && option != 'X'
    puts "\nEDIT SURVEY"
    puts "Enter 'N' to change the name of the survey"
    puts "Enter 'Q' to go to the question menu (to add, edit or delete questions)"
    puts "Enter 'P' to go back to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    case option
    when 'N'
      current_survey = get_survey_from_name
      if !current_survey.nil?
        change_survey_name(current_survey)
      else
        option = "P"
      end
    when 'Q'
      current_survey = get_survey_from_name
      if !current_survey.nil?
        question_menu(current_survey)
      else
        option = "P"
      end
    when 'P'
    when 'X'
      exit_program
    else
      "\nInvalid option entered, try again"
    end
  end
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

def delete_survey
  puts "\nDELETE SURVEY"
  current_survey = get_survey_from_name
  if !current_survey.nil?
    puts "\nAre you sure you want to delete this survey from the database?"
    puts "Enter 'Y' or 'YES' to delete (any other key will skip the deletion)"
    answer = gets.chomp.slice(0,1).upcase
    if answer == "Y"
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
  while option != "Please" && option != 'X'
    puts "\nQUESTION MENU"
    puts "Enter 'C' to create a question"
    puts "Enter 'L' to list all of the responses for a question"
    puts "Enter 'S' to list all of the questions for a survey"
    puts "Enter 'E' to edit the text of a question"
    puts "Enter 'R' to go to the response menu (to add, edit or delete responses)"
    puts "Enter 'D' to delete a question"
    puts "Enter 'P' to go back to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    if current_survey.nil? && option != "P" && option != "X" && option != "R"
      current_survey = get_survey_from_name
    elsif option == "X"
      exit_program
    end
    if option != "P" && !current_survey.nil? || option == "R"
      if !current_survey.nil?
        puts "\nCurrent survey is #{current_survey.name}\n"
      end
      case option
      when 'C'
        create_question(current_survey)
        current_survey = nil
      when 'L'
        list_responses_for_question(current_survey)
        current_survey = nil
      when 'S'
        list_questions_for_survey(current_survey)
      when 'E'
        edit_question_text(current_survey)
        current_survey = nil
      when 'D'
        delete_question(current_survey)
        current_survey = nil
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
  while option != "P" && option != "X"
    puts "Enter text for the question (100 character maximum)"
    input_text = gets.chomp
    new_question = Question.new(:question_text => input_text, :survey_id => current_survey.id)
    if new_question.save
      create_response(new_question)
    else
     puts "Please fix these errors:"
      new_question.errors.full_messages.each do |message|
        puts "#{message}"
      end
    end
    puts "\nEnter 'P' to go to the previous menu or enter 'X' to exit the program"
    puts "Enter any other character to continue adding questions to the survey #{current_survey.name}"
    option = gets.chomp.upcase
    if option == 'X'
      exit_program
    end
  end
end

def edit_question_text(current_survey)
  puts "\nEDIT QUESTION TEXT"
  question_array = []
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
        current_question.errors.full_messages.each do |message|
          puts "#{message}"
        end
      end
    end
  end
end

def list_responses_for_question(current_survey)
  puts "\nLIST RESPONSES FOR A QUESTION"
  response_array = []
  question_array = list_questions_for_survey(current_survey)
  if !question_array.empty?
    puts "\nSelect the index of the question whose responses you'd like to list"
    question_index = gets.chomp.to_i
    if question_index == 0 || question_index > question_array.length
      puts "\nInvalid index selected, try again"
    else
      current_question = question_array[question_index-1]
    end
    if !current_question.nil?
      puts "\nSurvey #{current_question.survey.name}, question text '#{current_question.question_text}' has " +
           "#{current_question.responses.count} responses:"
      response_array = current_question.responses.order(:response_letter)
      if !response_array.empty?
        response_array.each_with_index do |response, index|
          puts "#{index+1}. #{response.response_letter}: '#{response.response_text}'"
        end
        puts "\n"
      else
        puts "There are no responses for the question\n"
      end
    end
  end
  response_array
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
  if !question_array.empty?
    puts "\nSelect the index of the question you'd like to delete"
    question_index = gets.chomp.to_i
    if question_index == 0 || question_index > question_array.length
      puts "\nInvalid index selected, try again"
    else
      current_question = question_array[question_index-1]
    end
    if !current_question.nil?
      puts "\nAre you sure you want to delete this survey from the database?"
      puts "Enter 'Y' or 'YES' to delete (any other key will skip the deletion)"
      answer = gets.chomp.slice(0,1).upcase
      if answer == "Y"
        delete_all_responses(current_question)
        current_question.destroy
      else
        puts "\nNothing was deleted"
      end
    else
      puts "\nAn invalid question was selected, try again"
    end
  else
    puts "There are no questions for survey #{current_survey.name} in the database"
  end 
end

def response_menu(current_question)
  option = nil
  current_response = nil
  if !current_question.nil?
    current_survey = current_question.survey
  else
    current_survey = nil
  end
  while option != "P" && option != 'X'
    puts "\nRESPONSE MENU"
    puts "Enter 'C' to create a response"
    puts "Enter 'L' to list all of the responses for a question"
    puts "Enter 'R' to edit the letter of a response"
    puts "Enter 'T' to edit the text of a response"
    puts "Enter 'D' to delete a response"
    puts "Enter 'P' to go back to the previous menu"
    puts "Enter 'X' to exit the program\n"
    option = gets.chomp.upcase
    if option != "P" && option != "X" && !current_survey.nil?
      puts "\nCurrent survey is #{current_survey.name}\n"
    end
    if option != "P" && option != "X" && !current_question.nil?
      puts "\nCurrent question is #{current_question.text}\n"
    end
    case option
    when 'C'
      create_response(current_question)
      current_survey = nil
    when 'L'
      list_responses_for_question(current_survey)
      current_survey = nil
    when 'R'
      edit_response_letter(current_question)
      current_survey = nil
    when 'T'
      edit_response_text(current_question)
      current_survey = nil
    when 'D'
      delete_response(current_question)
      current_survey = nil
    when 'P'
    when 'X'
      exit_program
    else
      "\nInvalid option entered, try again"
    end
  end
end

def create_response(current_question)
  option = nil
  current_survey = nil
  puts "\nCREATE RESPONSE"
  while option != "P" && option != "X"
    if current_question.nil?
      question_array = list_questions_for_survey(current_survey)
      if !question_array.empty?
        puts "\nSelect the index of the question to which you'd like to add a response"
        question_index = gets.chomp.to_i
        if question_index == 0 || question_index > question_array.length
          puts "\nInvalid index selected, try again"
        else
          current_question = question_array[question_index-1]
        end
      end
    end
    input_letter = get_next_letter(current_question)
    puts "The next letter response will be #{input_letter}"
    puts "Enter text for the response (50 character maximum)"
    input_text = gets.chomp
    new_response = Response.new(:response_letter => input_letter, :response_text => input_text, :question_id => current_question.id)
    if !new_response.save
    puts "Please fix these errors:"
      new_response.errors.full_messages.each do |message|
        puts "#{message}"
      end
    end
    puts "\nEnter 'P' to go back to the previous menu or enter 'X' to enter the program"
    puts "Enter any other character to continue adding responses to the current question"
    option = gets.chomp.upcase
    if option == 'X'
      exit_program
    end
  end
end

def get_next_letter(current_question)
  response_array = []
  response_array = current_question.responses.order(:response_letter)
  if response_array.empty?
    return "A"
  else
    return response_array.last.response_letter.next
  end
end

def edit_response_letter(current_question)
  response_array = list_responses_for_question(current_question)
  if !response_array.empty?
    puts "\nSelect the index of the response whose letter you'd like to change"
    response_index = gets.chomp.to_i
    if response_index == 0 || response_index > response_array.length
      puts "\nInvalid index selected, try again"
    else
      current_response = response_array[response_index-1]
      puts "\nEnter the new text for the response"
      input_letter = gets.chomp.slice(0,1).upcase
      if !current_response.update(:response_letter=>input_letter)
        puts "Please fix these errors:"
        current_response.errors.full_messages.each do |message|
          puts "#{message}"
        end
      end
    end
  end
end

def edit_response_text(current_question)
  response_array = list_responses_for_question(current_question)
  if !response_array.empty?
    puts "\nSelect the index of the response whose text you'd like to change"
    response_index = gets.chomp.to_i
    if response_index == 0 || response_index > response_array.length
      puts "\nInvalid index selected, try again"
    else
      current_response = response_array[response_index-1]
      puts "\nEnter the new text for the response (50 character maximum)"
      input_text = gets.chomp
      if !current_response.update(:response_text=>input_text)
        puts "Please fix these errors:"
        current_response.errors.full_messages.each do |message|
          puts "#{message}"
        end
      end
    end
  end
end

def delete_all_responses(current_question)
  if !current_question.responses.empty?
    current_question.responses.each do |response|
      response.delete
    end
  end
end

def delete_response(current_question)
  current_response = nil
  puts "\nDELETE RESPONSE"
  if current_question.nil?
    current_survey = nil
    question_array = list_questions_for_survey(current_survey)
    if !question_array.empty?
      puts "\nSelect the index of the question from which you'd like to delete a response"
      question_index = gets.chomp.to_i
      if question_index == 0 || question_index > question_array.length
        puts "\nInvalid index selected, try again"
      else
        current_question = question_array[question_index-1]
      end
    end
  end
  response_array = list_responses_for_question(current_question.survey)
  puts "\nSelect the index of the response you'd like to delete"
  response_index = gets.chomp.to_i
  if !response_array.empty?
    if response_index == 0 || response_index > response_array.length
      puts "\nInvalid index selected, try again"
    else
      current_response = response_array[response_index-1]
    end
    if !current_response.nil?
      puts "\nAre you sure you want to delete this survey from the database?"
      puts "Enter 'Y' or 'YES' to delete (any other key will skip the deletion)"
      answer = gets.chomp.slice(0,1).upcase
      if answer == "Y"
        current_response.destroy
      else
        puts "\nNothing was deleted"
      end
    else
      puts "\nAn invalid question was selected, try again"
    end
  end
end

def taker_menu
  option = nil
  puts "\nPlease enter your name (25 character maximum)"
  input_name = gets.chomp.titleize
  taker_array = SurveyTaker.where("name = ?", input_name)
  if taker_array.empty?
    puts "\nYou have never taken a survey before from Cindy's Survey Company"
    puts "Please enter your phone number for our records (10-digit ddd-ddd-dddd format)"
    input_phone = gets.chomp
    if input_phone =~ /\d\d\d-\d\d\d-\d\d\d\d/
      @current_taker = SurveyTaker.create(:name => input_name, :phone_number => input_phone)
    else
      puts "\nInvalid format for phone number, try again"
      option = "M"
    end
  else
    @current_taker = taker_array.first
  end
  while option != 'M' && option != 'X'
    puts "\nSURVEY TAKER MENU"
    puts "Enter 'T' to select a survey to take"
    puts "Enter 'R' to review the surveys you have taken"
    puts "Enter 'M' to go to the main menu"
    puts "Enter 'X' to exit the program"
    option = gets.chomp.upcase
    case option
    when 'T'
      take_survey
    when 'R'
      review_surveys
    when 'M'
    when 'X'
      exit_program
    else
      puts "\nInvalid option entered, try again"
    end
  end
end

def take_survey
  survey_finished = false
  all_surveys = []
  all_surveys = list_all_surveys
  if !all_surveys.empty?
    puts "\nSelect the index of the survey you would like to take"
    survey_index = gets.chomp.to_i
    if survey_index == 0 || survey_index > all_surveys.length
      puts "\nInvalid index selected, please try again"
    else
      current_survey = all_surveys[survey_index-1]
      if !current_survey.taken
        puts "#{@current_taker.name}, you are the first person to take this survey!"
        puts "Please be sure to report any errors to the designer, #{current_survey.survey_designer.name}"
      end
      survey_finished = show_questions_and_capture_responses(current_survey)
      if survey_finished
        current_survey.update(:taken => true)
        new_survey_taken = TakenSurvey.create(:date => @today, :survey_id => current_survey.id, :survey_taker_id => @current_taker.id)
        puts "\nThank you for completing the survey about #{current_survey.name}."
        puts "We greatly appreciate your opinions!\n"
      else
        puts "\nYou did not finish the survey. You may retake it, but you will have to start again from the beginning\n"
      end
    end
  else
    puts "\nThere are no surveys in the database"
  end
end

def show_questions_and_capture_responses(current_survey)
  return_status = false
  current_survey.questions.each_with_index do |question, index|
    puts "\n#{index+1}. #{question.question_text}"
    puts "Please choose one of the following responses"
    possible_response_letters = []
    question.responses.each do |response|
      puts "#{response.response_letter}. #{response.response_text}"
      possible_response_letters << response.response_letter
    end
    answer_not_valid = true
    while answer_not_valid
      puts "\nPlease enter your response"
      answer = gets.chomp.upcase.slice(0,1)
      if !possible_response_letters.include?(answer)
        puts "\nSorry, that is not a valid response. Enter 'X' to exit the program or any other character to try again"
        option = gets.chomp.upcase
        if option == 'X'
          exit_program
        end
      else
        answer_not_valid = false
        chosen_response = question.responses.find_by(:response_letter => answer)
        new_chosen_response = ChosenResponse.create(:question_id => question.id, :response_id => chosen_response.id)
      end
    end
  end
end

def exit_program
  puts "\nThanks for visiting Cindy's Survey Company\n\n"
  exit
end

welcome
