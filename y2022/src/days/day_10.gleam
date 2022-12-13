import gleam/string
import gleam/list
import gleam/int
import helpers
import gleam/io

pub fn pt_1(input: String) {
  part1_test()
  input
  |> do_part1()
  |> int.sum()
}

pub fn pt_2(input: String) {
  part2_test()
  do_part2(input) |> io.debug()
}

fn part1_test() {
  let res = do_part1(part1_sample)
  assert 420 = helpers.list_at(res, 0)
  assert 13140 = int.sum(res)
}

fn part2_test() {
  assert True =
    part2_sample == do_part2(part1_sample)
}

fn do_part1(input) {
  let history = calc_history(input)
  let points = [20, 60, 100, 140, 180, 220]

  points
  |> list.fold(
    [],
    fn(acc, point) { [helpers.list_at(history, point - 1) * point, ..acc] },
  )
  |> list.reverse()
}

fn do_part2(input) {
  input |> calc_history()
  |> list.index_map(
    fn(cycle, value) {
      assert Ok(col) = int.remainder(cycle, 40)
      let diff = col + 1 - value
      case 0 <= diff && diff <= 2 {
        True -> "#"
        False -> "."
      }
    },
  )
  |> list.take(240)
  |> list.sized_chunk(into: 40)
  |> list.map(fn(chunk){string.join(chunk, "")})
  |> string.join("\n")
}

fn calc_history(input) {
  input
  |> helpers.lines()
  |> list.fold(
    [1],
    fn(acc, op) {
      let [head, ..rest] = acc
      case string.split(op, on: " ") {
        ["addx", arg_str] -> {
          let arg = helpers.parse_int(arg_str)
          [head + arg, head, head, ..rest]
        }

        ["noop"] -> [head, head, ..rest]
      }
    },
  )
  |> list.reverse()
}

const part1_sample = "addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop"

const part2_sample = "##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."
