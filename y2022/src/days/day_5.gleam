import gleam/string
import gleam/list
import gleam/int
import helpers
import gleam/regex
import gleam/option

pub fn pt_1(input: String) -> String {
  let lines = helpers.lines(input)

  let state =
    lines
    |> list.take(8)
    |> initial_state()

  lines
  |> list.drop(10)
  |> list.map(fn(line) { parse_move(line, re()) })
  |> list.fold(
    state,
    fn(acc, move) {
      let #(number, from, to) = move
      perform_multi_move(acc, number, from, to, True)
    },
  )
  |> list.map(fn(col) {
    let [first, ..] = col
    first
  })
  |> string.join(with: "")
}

pub fn pt_2(input: String) -> String {
  let lines = helpers.lines(input)

  let state =
    lines
    |> list.take(8)
    |> initial_state()

  lines
  |> list.drop(10)
  |> list.map(fn(line) { parse_move(line, re()) })
  |> list.fold(
    state,
    fn(acc, move) {
      let #(number, from, to) = move
      perform_multi_move(acc, number, from, to, False)
    },
  )
  |> list.map(fn(col) {
    let [first, ..] = col
    first
  })
  |> string.join(with: "")
}

fn re() {
  assert Ok(re) = regex.from_string("move (\\d+) from (\\d+) to (\\d+)")
  re
}

fn initial_state(lines) {
  lines
  |> list.map(fn(row) {
    row
    |> string.pad_right(to: 35, with: " ")
    |> string.to_graphemes()
    |> list.fold(
      #(0, []),
      fn(acc, letter) {
        let #(col, data) = acc
        case int.remainder(col - 1, 4) {
          Ok(0) -> #(col + 1, [letter, ..data])
          _ -> #(col + 1, data)
        }
      },
    )
  })
  |> list.map(fn(row) {
    let #(_, state_row) = row
    list.reverse(state_row)
  })
  |> list.transpose()
  |> list.map(fn(stack) {
    list.drop_while(stack, fn(element) { element == " " })
  })
}

fn parse_move(line, re) {
  let [regex.Match(content: _, submatches: submatches)] =
    regex.scan(with: re, content: line)
  let [option.Some(number_str), option.Some(from_str), option.Some(to_str)] =
    submatches
  let #(Ok(number), Ok(from), Ok(to)) = #(
    int.parse(number_str),
    int.parse(from_str),
    int.parse(to_str),
  )
  #(number, from, to)
}

fn perform_multi_move(state, number, from, to, reverse_popped) {
  let #(popped, reversed_popped_state) =
    list.index_fold(
      state,
      #([], []),
      fn(acc, stack, col) {
        let #(answer, acc_state) = acc
        case from == col + 1 {
          True -> {
            let popped = list.take(stack, number)
            let rest = list.drop(stack, number)
            #(popped, [rest, ..acc_state])
          }
          False -> #(answer, [stack, ..acc_state])
        }
      },
    )

  let popped_state = list.reverse(reversed_popped_state)

  let maybe_reversed_popped = case reverse_popped {
    True -> list.reverse(popped)
    False -> popped
  }

  let reversed_pushed_state =
    list.index_fold(
      popped_state,
      [],
      fn(acc, stack, col) {
        case to == col + 1 {
          True -> [list.append(maybe_reversed_popped, stack), ..acc]
          False -> [stack, ..acc]
        }
      },
    )

  list.reverse(reversed_pushed_state)
}
