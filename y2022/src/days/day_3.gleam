import gleam/string
import gleam/list
import gleam/int
import helpers

pub fn pt_1(input: String) -> Int {
  input
  |> helpers.lines()
  |> list.map(fn(line) {
    let [first, second] = helpers.split_at(line, string.length(line) / 2)
    assert True = string.length(first) == string.length(second)
    let fst_letters = string.to_graphemes(first)
    let res =
      list.filter(fst_letters, fn(letter) { string.contains(second, letter) })
    let [duplicate, .._] = res
    assert True = list.unique(res) == [duplicate]
    assert True = duplicate != ""
    priority(duplicate)
  })
  |> int.sum()
}

pub fn pt_2(input: String) -> Int {
  let lines = helpers.lines(input)
  let #(groups, remainder) =
    list.fold(
      list.range(0, list.length(lines) / 3 - 1),
      #([], lines),
      fn(acc, _) {
        let #(answer, lines) = acc
        #([list.take(lines, 3), ..answer], list.drop(lines, 3))
      },
    )
  assert True = remainder == []

  groups
  |> list.map(fn(group) {
    let [fst, snd, thd] = group
    let duplicates =
      list.filter(
        string.to_graphemes(fst),
        fn(letter) { string.contains(snd, letter) },
      )
    let res =
      list.filter(duplicates, fn(letter) { string.contains(thd, letter) })
    let [duplicate, .._] = res
    assert True = list.unique(res) == [duplicate]
    assert True = duplicate != ""
    priority(duplicate)
  })
  |> int.sum()
}

pub fn priority(grapheme) {
  let <<char:int>> = <<grapheme:utf8>>
  let <<a:int>> = <<"a":utf8>>
  let <<z:int>> = <<"z":utf8>>
  let <<aa:int>> = <<"A":utf8>>

  let res = case a <= char && char <= z {
    True -> char - a + 1
    False -> char - aa + 27
  }

  assert True = 0 <= res && res <= 52
  res
}
