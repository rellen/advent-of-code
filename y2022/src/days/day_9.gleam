import gleam/string
import gleam/list
import gleam/int
import helpers
import gleam/order

type Pos {
  Pos(x: Int, y: Int)
}

type State {
  State(knots: List(Pos), visited: List(Pos))
}

pub fn pt_1(input: String) -> Int {
  part1_test()
  do_part1(input)
}

pub fn pt_2(input: String) {
  part2_test()
  do_part2(input)
}

fn part1_test() {
  let test_input = "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2"
  assert 13 = do_part1(test_input)
}

fn part2_test() {
  let test_input = "R 5\nU 8\nL 8\nD 3\nR 17\nD 10\nL 25\nU 20"
  assert 36 = do_part2(test_input)
}

const origin = Pos(x: 0, y: 0)

fn do_part1(input) {
  let initial_state = State(knots: [origin, origin], visited: [origin])
  do_moves(input, initial_state)
}

fn do_part2(input) {
  let initial_state = State(knots: list.repeat(origin, 10), visited: [origin])
  do_moves(input, initial_state)
}

fn do_moves(input, initial_state) {
  let final_state =
    input
    |> helpers.lines()
    |> list.fold(
      initial_state,
      fn(state, command) {
        let [direction, spaces_str] = string.split(command, on: " ")
        let spaces = helpers.parse_int(spaces_str)

        case direction {
          "L" ->
            list.fold(
              list.range(1, spaces),
              state,
              fn(state, _step) { move(state, -1, 0) },
            )
          "R" ->
            list.fold(
              list.range(1, spaces),
              state,
              fn(state, _step) { move(state, 1, 0) },
            )
          "U" ->
            list.fold(
              list.range(1, spaces),
              state,
              fn(state, _step) { move(state, 0, 1) },
            )
          "D" ->
            list.fold(
              list.range(1, spaces),
              state,
              fn(state, _step) { move(state, 0, -1) },
            )
        }
      },
    )

  final_state.visited
  |> list.unique()
  |> list.length()
}

fn move(state, dx, dy) {
  let [head, ..tail] = state.knots
  let new_head = Pos(x: head.x + dx, y: head.y + dy)

  let new_knots =
    list.fold(
      tail,
      [new_head],
      fn(acc, knot) {
        let [head, ..] = acc
        case touching(head, knot) {
          True -> [knot, ..acc]
          False -> {
            let dx = order.to_int(int.compare(head.x, knot.x))
            let dy = order.to_int(int.compare(head.y, knot.y))
            let new_knot = Pos(x: knot.x + dx, y: knot.y + dy)
            [new_knot, ..acc]
          }
        }
      },
    )

  let [h, ..] = new_knots

  State(knots: list.reverse(new_knots), visited: [h, ..state.visited])
}

fn touching(pos1, pos2) {
  let Pos(x: x1, y: y1) = pos1
  let Pos(x: x2, y: y2) = pos2
  int.absolute_value(x2 - x1) < 2 && int.absolute_value(y2 - y1) < 2
}
