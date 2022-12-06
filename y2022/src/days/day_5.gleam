import gleam/string
import gleam/list
import gleam/int
import helpers
import gleam/regex
import gleam/option
import gleam/io

pub fn pt_1(input: String) -> Int {
  let lines = helpers.lines(input)

  assert Ok(re) = regex.from_string("move (\\d+) from (\\d+) to (\\d+)")

  let state =
    lines
    |> list.take(8)
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

  let moves =
    lines
    |> list.drop(10)
    |> list.map(fn(line) { parse_move(line, re) })
    |> list.map(fn(moves) {
      let #(number, from, to) = moves

      list.repeat(#(from, to), times: number)
    })
    |> list.flatten()
    |> list.fold(
      state,
      fn(acc, move) {
        let #(from, to) = move
        io.debug(move)
        perform_move(acc, from, to)
      },
    )
    |> io.debug
    |> list.map(fn(col) {
      let [first, ..] = col
      first
    })
    |> string.join(with: "")
    |> io.debug()
  0
}

pub fn pt_2(input: String) -> Int {
  todo
}

pub fn parse_move(line, re) {
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

pub fn perform_move(state, from, to) {
  let #(popped, reversed_popped_state) =
    list.index_fold(
      state,
      #("", []),
      fn(acc, stack, col) {
        let #(answer, acc_state) = acc
        case from == col + 1 {
          True -> {
            let [first, ..rest] = stack
            #(first, [rest, ..acc_state])
          }
          False -> #(answer, [stack, ..acc_state])
        }
      },
    )

  let popped_state = list.reverse(reversed_popped_state)

  let reversed_pushed_state =
    list.index_fold(
      popped_state,
      [],
      fn(acc, stack, col) {
        case to == col + 1 {
          True -> [[popped, ..stack], ..acc]
          False -> [stack, ..acc]
        }
      },
    )

  list.reverse(reversed_pushed_state)
}
