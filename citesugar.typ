#import "genitive.typ" as genitive

/// Form a genitive from an author name
/// depending on the current `text.locale`.
///
/// -> content
#let lang-genitive(
  /// -> content
  author,
  /// Override the lang -> genitive-function mapping.
  /// See `genitive.genitives` for more info.
  mapping: genitive.genitives
) = context {
  genitive.genitives.at(text.lang, default: genitive.genitives.en)(author)
}

#let cite-bare(key, supplement: none, style: auto) = {
  show regex("[\(\)\[\]]"): none
  cite(key, supplement: supplement, style: style)
}

#let cite-genitive(key, supplement: none, style: auto, form: "prose") = {
    show regex("^[^\[\(]+"): it => {
      show regex("([^\s]*\s)*[^\s]+"): lang-genitive
      it
    }
  cite(key, form: form, supplement: supplement)
}
#let cite-prose-genitive = cite-genitive.with(form: "prose")
#let cite-author-genitive = cite-genitive.with(form: "author")

#let base-forms = (
    // Davidson (1970)
    "p": (key, suppl) => cite(key, form: "prose", supplement: suppl),
    // Davidson's (1970), Lewis' (1986)
    "ps": (key, suppl) => cite-prose-genitive(key, supplement: suppl),
    // Davidson 1970
    "b": (key, suppl) => cite-bare(key, supplement: suppl),
    // Davidson
    "a": (key, suppl) => cite(key, form: "author", supplement: suppl),
    // Davidson's (1970), Lewis' (1986)
    "as": (key, suppl) => cite-author-genitive(key, supplement: suppl),
    // 1970
    "y": (key, suppl) => cite(key, form: "year", supplement: suppl),
)

#let citesugar(
  it,
  /// Custom forms in addition or overriding to the default ones.
  /// Accepts a dictionary where keys are prefixes
  /// and values are functions of type `(target, supplement) => content`
  /// -> dictionary
  forms: (: )
) = {
  let forms = base-forms + forms
  let suppl = it.supplement

  if (
    suppl not in (none, auto, []) 
    and suppl.has("children")
    and suppl.at("children").at(1) == [:]
  ) {
    let children = suppl.at("children")
    let abbr = (children.at(0).text)
    let supplement = children.slice(2).join()

    if abbr in forms {
      forms.at(abbr)(it.key, supplement)
    } else {
      cite(it.key, supplement: supplement)
    }

  } else {
    it
  }
}
