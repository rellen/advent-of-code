import gleam/erlang/file
import gleam/string
import gleam/list
import gleam/int

pub fn part1() {
  assert Ok(res) = file.read("src/day01.txt")
  process_part1(res)
}

pub fn process_part1(str) {
  str
  |> totals()
  |> list.fold(0, fn(acc, num) { int.max(acc, num) })
}

pub fn part2() {
  assert Ok(res) = file.read("src/day01.txt")
  process_part2(res)
}

pub fn process_part2(str) {
  str
  |> totals()
  |> list.sort(by: int.compare)
  |> list.reverse()
  |> list.take(3)
  |> int.sum()
}

pub fn totals(str) {
  str
  |> group()
  |> list.map(fn(grp) {
      grp
      |> parse_ints()
      |> int.sum()
    })
}

pub fn group(str: String) {
  str
  |> string.split(on: "\n")
  |> list.fold(
    [[]],
    fn(acc, str) {
      let [h, ..rest] = acc
      case #(h, str) {
        #([], "") -> [h, ..rest]
        #(_, "") -> [[], h, ..rest]
        _ -> [[str, ..h], ..rest]
      }
    },
  )
}

pub fn parse_ints(ints) {
  list.map(
    ints,
    fn(str) {
      assert Ok(num) = int.parse(str)
      num
    },
  )
}
