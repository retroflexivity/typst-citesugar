#import "../../citesugar.typ": citesugar
#show cite: citesugar.with(
  forms: (
    "b": (key, suppl) => cite(key, supplement: suppl),
    "x": (key, suppl) => [#repr(key), #suppl]
  )
)

@johnson[b:p. 1]

@johnson[x:p. 1]

#bibliography("bib.yaml", style: "chicago-author-date")
