require 'yaml'

at_exit do
	keys = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'yubikey_mappings.yml'))
	mapping_string = "ubuntu:#{mappings_to_string(keys)}\n"
	abort if mapping_string == read_mappings
	write_mappings(mapping_string)
end

def mappings_to_string(keys)
	keys["yubikeys"].map { |k,v| v }.join(":")
end

def read_mappings(filename = 'yubikey_mappings')
	full_filename = filename(filename)
	IO.read(full_filename)
end

def write_mappings(contents, filename = 'yubikey_mappings')
	full_filename = filename(filename)
	File.open(full_filename, 'w') {|f| f.write(contents) }
end

def filename(filename)
	File.join(File.dirname(File.expand_path(__FILE__)), filename)
end