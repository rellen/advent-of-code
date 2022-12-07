import gleam/string
import gleam/list

pub fn pt_1(input: String) {
  assert 5 = do_part1("bvwbjplbgvbhsrlpgdmjqwftvncz")
  assert 6 = do_part1("nppdvjthqldpwncqszvftbrmjlhg")
  assert 10 = do_part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
  assert 11 = do_part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  do_part1(input)
}

pub fn pt_2(input: String) {
  assert 19 = do_part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
  assert 23 = do_part2("bvwbjplbgvbhsrlpgdmjqwftvncz")
  assert 23 = do_part2("nppdvjthqldpwncqszvftbrmjlhg")
  assert 29 = do_part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
  assert 26 = do_part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  do_part2(input)
}

fn do_part1(input) {
  unique_window(input, 4)
}

fn do_part2(input) {
  unique_window(input, 14)
}

fn unique_window(input, window) {
  input
  |> string.to_graphemes()
  |> list.window(by: window)
  |> list.fold_until(
    window,
    fn(acc, elem) {
      case list.unique(elem) == elem {
        True -> list.Stop(acc)
        False -> list.Continue(acc + 1)
      }
    },
  )
}
