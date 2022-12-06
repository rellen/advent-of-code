import gleam/string
import gleam/list
import gleam/int
import gleam/order

pub fn pt_1(input: String) -> Int {
  process_part1(input)
}

pub fn pt_2(input: String) -> Int {
  process_part2(input)
}

pub fn process_part1(str) {
  str
  |> elf_calorie_totals()
  |> list.fold(0, fn(acc, num) { int.max(acc, num) })
}

pub fn process_part2(str) {
  str
  |> elf_calorie_totals()
  |> list.sort(by: reverse_compare)
  |> list.take(3)
  |> int.sum()
}

pub fn elf_calorie_totals(str) {
  str
  |> string.split(on: "\n\n")
  |> list.map(fn(grp) {
    grp
    |> string.split(on: "\n")
    |> list.fold(0, accumulate_string)
  })
}

pub fn accumulate_string(sum, str) {
  assert Ok(num) = int.parse(str)
  sum + num
}

pub fn reverse_compare(a, b) {
  case int.compare(a, b) {
    order.Gt -> order.Lt
    order.Lt -> order.Gt
    order.Eq -> order.Eq
  }
}
