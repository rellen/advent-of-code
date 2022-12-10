import gleam/string
import gleam/list
import helpers

pub fn pt_1(input: String) {
  part1_test()
  do_part1(input)
}

pub fn pt_2(input: String) {
  part2_test()
  do_part2(input)
}

fn part1_test() {
  let test_input = "30373\n25512\n65332\n33549\n35390"
  assert 21 = do_part1(test_input)
}

fn part2_test() {
  let test_input = "30373\n25512\n65332\n33549\n35390"
  assert 8 = do_part2(test_input)
}

fn do_part1(input) {
  let trees = get_trees(input)
  let trees_transposed = list.transpose(trees)

  trees
  |> list.index_map(fn(rowi, row) {
    list.index_map(
      row,
      fn(coli, _tree) { visible(trees, trees_transposed, rowi, coli) },
    )
  })
  |> list.flatten()
  |> list.filter(fn(p) { p == True })
  |> list.length()
}

fn do_part2(input) {
  let trees = get_trees(input)
  let trees_transposed = list.transpose(trees)

  trees
  |> list.index_map(fn(rowi, row) {
    list.index_map(
      row,
      fn(coli, _tree) { score(trees, trees_transposed, rowi, coli) },
    )
  })
  |> list.flatten()
  |> helpers.max_in_list(-1)
}

fn get_trees(input) {
  input
  |> helpers.lines()
  |> list.map(fn(line) { string.to_graphemes(line) })
  |> list.map(fn(line) {
    line
    |> list.map(fn(char) { helpers.parse_int(char) })
  })
}

fn visible(trees, trees_transposed, row, col) {
  visible_left(trees, row, col) || visible_right(trees, row, col) || visible_up(
    trees,
    trees_transposed,
    row,
    col,
  ) || visible_down(trees, trees_transposed, row, col)
}

fn visible_left(trees, rowi, coli) {
  let target =
    trees
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)
  let max =
    trees
    |> helpers.list_at(rowi)
    |> list.take(coli)
    |> helpers.max_in_list(-1)
  max < target
}

fn visible_right(trees, rowi, coli) {
  let target =
    trees
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)
  let max =
    trees
    |> helpers.list_at(rowi)
    |> list.drop(coli + 1)
    |> helpers.max_in_list(-1)
  max < target
}

fn visible_up(trees_orig, trees_transposed, rowi, coli) {
  let target =
    trees_orig
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)
  let max =
    trees_transposed
    |> helpers.list_at(coli)
    |> list.take(rowi)
    |> helpers.max_in_list(-1)
  max < target
}

fn visible_down(trees_orig, trees_transposed, rowi, coli) {
  let target =
    trees_orig
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)
  let max =
    trees_transposed
    |> helpers.list_at(coli)
    |> list.drop(rowi + 1)
    |> helpers.max_in_list(-1)
  max < target
}

fn score(trees, trees_transposed, row, col) {
  score_up(trees, trees_transposed, row, col) * score_left(trees, row, col) * score_down(
    trees,
    trees_transposed,
    row,
    col,
  ) * score_right(trees, row, col)
}

fn score_left(trees, rowi, coli) {
  let target =
    trees
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)

  trees
  |> helpers.list_at(rowi)
  |> list.take(coli)
  |> list.reverse()
  |> list.fold_until(
    [],
    fn(acc, x) {
      case x < target {
        True -> list.Continue([x, ..acc])
        False -> list.Stop([x, ..acc])
      }
    },
  )
  |> list.length()
}

fn score_right(trees, rowi, coli) {
  let target =
    trees
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)

  trees
  |> helpers.list_at(rowi)
  |> list.drop(coli + 1)
  |> list.fold_until(
    [],
    fn(acc, x) {
      case x < target {
        True -> list.Continue([x, ..acc])
        False -> list.Stop([x, ..acc])
      }
    },
  )
  |> list.length()
}

fn score_up(trees_orig, trees_transposed, rowi, coli) {
  let target =
    trees_orig
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)

  trees_transposed
  |> helpers.list_at(coli)
  |> list.take(rowi)
  |> list.reverse()
  |> list.fold_until(
    [],
    fn(acc, x) {
      case x < target {
        True -> list.Continue([x, ..acc])
        False -> list.Stop([x, ..acc])
      }
    },
  )
  |> list.length()
}

fn score_down(trees, trees_transposed, rowi, coli) {
  let target =
    trees
    |> helpers.list_at(rowi)
    |> helpers.list_at(coli)

  trees_transposed
  |> helpers.list_at(coli)
  |> list.drop(rowi + 1)
  |> list.fold_until(
    [],
    fn(acc, x) {
      case x < target {
        True -> list.Continue([x, ..acc])
        False -> list.Stop([x, ..acc])
      }
    },
  )
  |> list.length()
}
