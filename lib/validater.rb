# frozen_string_literal: true

require_relative "validater/version"
require "open-uri"
require "json"

module Validater
  class Error < StandardError; end

  def self.get(options = {})
    email = options.fetch(:email,"").to_s
    ip = options.fetch(:ip,"").to_s
    dns = options.fetch(:dns,"").to_s
    domaine = options.fetch(:domaine,"").to_s

      #email verification
    if email != ""
      response = URI.open("https://scraper.run/email?addr=#{email}").read #getting information from the api
        data = JSON.parse(response) #making that information into an object we can use !
        if data["domain"] == "" #second layer of verfication
        return "This is not a valid email addresse"
      else
        return "\n\tYour email's domaine is : #{data["domain"]},
        The hostname is : #{data["hostname"]},
        The user name is #{data["username"]},
        this is a valid email"
      end

      #ip verification
    elsif ip != ""
      response = URI.open("https://scraper.run/ip?addr=#{ip}").read
      data = JSON.parse(response)
      if data["addr"] == "" or data["code"] == "Invalid IP address."
        return "This is not a valid ip addresse"
      else
        return "\n\tThe ip that you entered is : #{data["addr"]},
        The country that this ip belongs to is : #{data["country"]},
        The city that this ip addresse is assighned to is : #{data["city"]},
        This is a valid ip adresse"
      end

      #dns verification
    elsif dns != ""
      response = URI.open("https://scraper.run/dns?addr=#{dns}").read
      data = JSON.parse(response)
      if data["ip"] == []
        return "This is not a valid dns"
      else
        return "\n\tThe ip and the domaine addresse is : [#{data["ip"][0]}], [#{data["ip"][2]}]
        The maile exchange protocols are : #{data["mx"]},
        The varfication methods are : #{data["txt"]},
        This is a valid dns"
      end

      #domaine vaerification
    elsif domaine != ""
      response = URI.open("https://scraper.run/whois?addr=#{domaine}").read
      data = JSON.parse(response)
      if data == {}
        return "This is not a valid domaine"
      else
        return "\n\tThe domaine infromation is  #{"\n\t{id : " + data["domain"]["id"] +
        "\n\tThe server is : " + data["domain"]["whois_server"] +
        "\n\tThe date of creation is : " + data["domain"]["created_date"] +"}"},
        The organisation where the domaine is registered : #{data["registrant"]["organization"]}
        The place of the company that it was registered at is : #{data["registrant"]["province"]}"
      end
    else
      return KeyError.new(message="No arguments recived, Run '#{File.basename($0)}' --help for details")
    end
  end
end

