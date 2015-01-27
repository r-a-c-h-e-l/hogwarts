require "sinatra"
require "pry"

wizards = {
  0 => {
    id: 0,
    name: "Harry Potter",
    age: "too old",
    "favorite spell"=> "accio",
    house: ""
  }
}
houses = {
  gryffindor: [],
  ravenclaw: [],
  hufflepuff: [],
  slytherin: []
}
counter = 1

get "/students" do
  erb :index, locals: {wizards: wizards, search: ""}
end

get "/student/:id" do
  this_wizard = wizards[params[:id].to_i]
  erb :show, locals:{wizard: this_wizard}
end

get "/search" do
  search = params["search"].downcase
  i = 0
  wizard = []
  wizards.each do |key,value|
    if value[:name].downcase == search
      i += 1
      wizard << wizards[key]
    end
  end
  if i == 0
    erb :index, locals: {wizards: wizards, search: {}}
  else
    erb :index, locals: {wizards: wizards, search: wizard}
  end
end

get "/houses/:house_name" do
  house = params[:house_name].intern
  this_house = {}
  this_house[house] = []
  wizards.each do |key,value|
    if value[:house] == params[:house_name]
      this_house[house]<< wizards[key]
    end
  end
  puts this_house
  erb :houses, locals: {house: this_house}
end

post "/student" do
  newwizard = {
    id: counter,
    name: params["name"],
    age: params["age"],
    "favorite spell"=> params["fav_spell"],
    house: ""
  }

  wizards[counter] = newwizard
  counter += 1

  redirect "/students"
end

put "/student/:id" do
  wizard= wizards[params[:id].to_i]
  wizard[params["category"].intern]= params["fact"]

  redirect "/student/#{params[:id].to_i}"
end

put "/sort/:id" do
  this_wizard = wizards[params[:id].to_i]
  houses_array = ["gryffindor","ravenclaw","hufflepuff","slytherin"]
  # houses_array = houses.keys
  house = houses_array.sample
  this_wizard[:house] = house
  # houses[house] << this_wizard[:name]

  redirect "/students"
end

delete "/student/:id" do
  wizards.delete(params[:id].to_i)
  redirect "/students"
end
