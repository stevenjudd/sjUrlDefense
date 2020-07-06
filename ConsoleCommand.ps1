# an example URL protected by URL Defense
$url = "https://urldefense.com/v3/__https://github.com/stevenjudd/sjUrlDefense__;!!J9_hdUX_JbjuLQ!_mpQgRsIaawOILsUWxCcr5y3kFNhQir7iT8vEvcJzL8J4OfrN2b3ichHNbkMj4c$"
# making sure it can pull the URL from the variable using the double-underscore
$url | sls "__.*?__"
# check what is contained in the object
$url | sls "__.*?__" | gm
# looking inside the Matches property
$url | sls "__.*?__" | select matches
# whoops. It is an object. Need to expand the object
$url | sls "__.*?__" | select -ExpandProperty matches
# the Value property has the URL
$url | sls "__.*?__" | select -ExpandProperty matches | select value
# return just the value property contents
($url | sls "__.*?__" | select -ExpandProperty matches).value
# remove the double-underscores
($url | sls "__.*?__" | select -ExpandProperty matches).value -replace "__", ""
# a potential problem would be if the URL had double-underscores inside the outside double-underscores
# this would break the URL, so only the first and last set should be removed
# Let's test that by adding double-underscores to the URL
$url2 = "https://urldefense.com/v3/__https://github.com/steven__judd/sjUrlDefense__;!!J9_hdUX_JbjuLQ!_mpQgRsIaawOILsUWxCcr5y3kFNhQir7iT8vEvcJzL8J4OfrN2b3ichHNbkMj4c$"
# make sure the Select-String still works
$url2 | sls "__.*?__"
# check the value
($url2 | sls "__.*?__" | select -ExpandProperty matches).value
# oops. There is also a problem with the RegEx. Need to fix that first.
($url2 | sls "__.*__" | select -ExpandProperty matches).value
# now for the replace
($url2 | sls "__.*__" | select -ExpandProperty matches).value -replace "__", ""
# it removed all of the double-underscores, which will break the URL
# to fix this, use substring to remove the first 2 and last 2 characters
($url2 | sls "__.*__" | select -ExpandProperty matches).value.substring(2, ($url2 | sls "__.*__" | select -ExpandProperty matches).length - 4)
# or 
($url2 | sls "__.*__").matches.value.substring(2, ($url2 | sls "__.*__").matches.value.length - 4)
# or 
($url2 | sls "__.*__" -OutVariable SearchResult | select -ExpandProperty matches).value.substring(2, ($SearchResult | select -ExpandProperty matches).length - 4)
# or
$SearchScope = $url2 | sls "__.*__" ; ($SearchScope | select -ExpandProperty matches).value.substring(2, ($SearchScope | select -ExpandProperty matches).length - 4)

