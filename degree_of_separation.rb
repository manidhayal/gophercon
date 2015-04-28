require './graph'
require './node'
require './edge'
require './breath_first_search'
require 'open-uri'	
require 'json'
require 'yaml'
require 'openssl'

class DegreeOfSeparation
	def initialize
		@graph = YAML::load(read_yaml) || Graph.new
	end

	def read_yaml
		File.exist?('./graph.yaml') ? File.open('./graph.yaml', "r").read : ""
	end

	def write_to_yaml
		File.open('./graph.yaml', 'w+') do |f|
			f.write(YAML::dump(@graph))
		end
	end

	def breath_first_search(src_node, dest_node)
		bfs = BreathFirstSearch.new(@graph, src_node)
		bfs.shortest_path_to(dest_node)
	end

	def get_data_from_movie_buff(url)
		uri = URI.parse("https://data.moviebuff.com/" + url)
		a = open(uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
		JSON.parse(a.read)
	end
	
	def populate_graph(node)
		data = 	get_data_from_movie_buff(node.name)
		return if data['type'] != 'Person'
		data['movies'].each do |movie|
			movie_data = get_data_from_movie_buff(movie['url'])
			next if movie_data['type'] != 'Movie'
			movie_data['cast'].each do |cast_person|
				next if node.name == cast_person['url']
				person_node = @graph.get_node(cast_person['url'])
				if !person_node
					person_node = Node.new(cast_person['url'])
					@graph.add_node(person_node)
				end
				@graph.add_edge(node, person_node)
			end
		end
	end

	def create_node_and_populate_graph(name)
		node = Node.new(name)
		@graph.add_node(node)
		populate_graph(node)
		node
	end

	def distance_between_two_nodes(src_name, dest_name)
		src_name = src_name.downcase.gsub(" ", "-")
		dest_name = dest_name.downcase.gsub(" ", "-")
		
		src_node = @graph.get_node(src_name)
		if src_node.nil?
			src_node = create_node_and_populate_graph(src_name)
		end

		dest_node = @graph.get_node(dest_name)
		if dest_node.nil?
			dest_node = create_node_and_populate_graph(dest_name)
		end
		path = breath_first_search(src_node, dest_node)
		
		write_to_yaml

		puts "Path:"
		puts path
		puts "Degree of separation :" + (path.nil? ? "None" : (path.size - 1).to_s)
	end
end

DegreeOfSeparation.new().distance_between_two_nodes(ARGV[0], ARGV[1])