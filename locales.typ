/// A dictionary of form `(lang: func)`,
/// where `func :: content -> content`
/// creates a genitive form from an author's name.
#let genitives = (
  en: c => {
    show regex(".+"): it => it + "’"
    show regex("[^s]’"): it => it + "s"
    c
  },
  de: c => {
    show "@": ""
    show regex(".*[sz]@"): it => it + "’"
    show regex(".*[^.sz’]@"): it => it + "s"
    c + "@"
  },
)
