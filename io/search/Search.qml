import QtQuick

QtObject {
  property list<var> providers: [
    ApplicationSearchProvider,
    FileSearchProvider,
    WindowSearchProvider,
    CalculatorSearchProvider,
    UnitsSearchProvider,
  ]
  // TODO: sigils (>&$#%) for each search provider
  // ideally they can be multiple characters

  // Basic relevance score for a result's title against the query: an exact prefix
  // match outranks a substring match, an earlier substring position outranks a later
  // one, and among equally-positioned matches a shorter title outranks a longer one.
  // Results whose title doesn't contain the query at all (e.g. matched via a
  // provider's own subtitle/genericName check) still get ranked, just below title
  // matches.
  function relevanceScore(item: var, query: string): real {
    const title = String(item.title ?? "");
    const lowerTitle = title.toLowerCase();
    const lowerQuery = query.toLowerCase();
    const index = lowerTitle.indexOf(lowerQuery);
    if (index === 0) return 20000 - title.length;
    if (index > 0) return 10000 - index * 10 - title.length;
    return -title.length;
  }

  function search(query: string): list<var> {
    const results = providers.flatMap(provider => provider.search(query));
    if (query.length === 0) return results;
    return results.slice().sort((a, b) => relevanceScore(b, query) - relevanceScore(a, query));
  }
}
