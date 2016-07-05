require 'rdf' 
require 'linkeddata'


graph = RDF::Graph.load("foaf.rdf")
puts graph.inspect


# return everyone I know
query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
 WHERE { ?s foaf:knows ?o }
"

# load everyone I know's foaf file into the same graph as mine
puts "beforeloading"
sse = SPARQL.parse(query)
sse.execute(graph) do |result|
 puts result.o
 rdf = RDF::Resource(RDF::URI.new(result.o))
 graph.load(result.o)
end

puts "afterloading"
sse.execute(graph) do |result|
 puts result.o
end

# show interests of people I know
interests_query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
 WHERE { ?s foaf:interest ?o }
"

puts "Interests of people I know"
sse_interests = SPARQL.parse (interests_query)
sse_interests.execute(graph) do |result|
  puts result.o
end


# bess_rdf = RDF::Resource(RDF::URI.new("http://www.stanford.edu/~laneymcg/laney.rdf"))
#
# hacker_nt = RDF::Resource(RDF::URI.new("http://www.stanford.edu/~arcadia/foaf.rdf"))
#
# # Load multiple RDF files into the same RDF::Repository object
# queryable = RDF::Repository.load(hacker_nt)
# queryable.load(bess_rdf)
#
# sse = SPARQL.parse(query)
# sse.execute(queryable) do |result|
#  puts result.o
# end