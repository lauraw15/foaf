require 'rdf' 
require 'linkeddata'
graph = RDF::Graph.load("foaf.rdf")
puts graph.inspect

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT *
 WHERE { ?s foaf:knows ?o }
"
puts "beforeloading"
sse = SPARQL.parse(query)
sse.execute(graph) do |result|
 puts result.o
 rdf = RDF::Resource(RDF::URI.new(result.o))
 graph.load(rdf)
end
puts "afterloading"
sse.execute(graph) do |result|
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