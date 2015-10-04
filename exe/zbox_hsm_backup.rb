#!/usr/bin/env ruby

require 'bundler/setup'
require 'zbox_hsm_backup'
require 'optparse'
require 'parallel'

ARGV << '-h' if ARGV.empty?

options = {}
optparse = OptionParser.new do |opts|
 opts.banner = "Usage: zbox_hsm_backup -s [HSM STATUS: online | offline]"

 opts.on("-sSTATUS", "--status=STATUS", "Respaldar HSM activo o inactivo") do |o|
   options[:status] = o
 end

 opts.on("-tRCPT", "--to=RCPT", "Quien recibe el email") do |o|
   options[:to] = o
 end

 opts.on("-mMTA", "--mta=MTA", "Servidor para envio de correo") do |o|
   options[:mta] = o
 end

end

optparse.parse!

ZboxHsmBackup.start options
