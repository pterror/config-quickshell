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

  function search(query: string): list<var> {
    return providers.flatMap(provider => provider.search(query))
  }
}
