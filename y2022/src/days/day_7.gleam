import gleam/string
import gleam/list
import gleam/int
import helpers

type File {
  File(name: String, size: Int)
}

type Dir {
  Dir(name: String, files: List(File), dirs: List(Dir), size: Int)
}

pub fn pt_1(input: String) {
  assert 95437 = do_part1(test_input())
  do_part1(input)
}

pub fn pt_2(input: String) {
  assert 24933642 = do_part2(test_input())
  do_part2(input)
}

fn do_part1(input) {
  input
  |> helpers.lines()
  |> list.fold([], fn(env, line) { process_line(env, line) })
  |> return_to_root()
  |> find_sizes_below(100000)
  |> int.sum()
}

fn do_part2(input) {
  let root =
    input
    |> helpers.lines()
    |> list.fold([], fn(env, line) { process_line(env, line) })
    |> return_to_root()

  let free_space = 70000000 - root.size
  let have_to_delete = 30000000 - free_space

  root
  |> find_sizes_above(have_to_delete)
  |> list.fold(root.size, fn(min, dir_size) { int.min(min, dir_size) })
}

fn test_input() {
  "$ cd /\n$ ls\ndir a\n14848514 b.txt\n8504156 c.dat\ndir d\n$ cd a\n$ ls\ndir e\n29116 f\n2557 g\n62596 h.lst\n$ cd e\n$ ls\n584 i\n$ cd ..\n$ cd ..\n$ cd d\n$ ls\n4060174 j\n8033020 d.log\n5626152 d.ext\n7214296 k"
}

fn process_line(env: List(Dir), line) {
  case string.split(line, on: " ") {
    ["$", "cd", "/"] -> [Dir(name: "/", files: [], dirs: [], size: 0)]
    ["$", "cd", ".."] -> go_up(env)
    ["$", "cd", name] -> go_down(env, name)
    ["$", "ls"] -> env
    ["dir", _name] -> env
    [size, name] -> file(env, name, helpers.parse_int(size))
  }
}

fn go_up(env) {
  let [curr, prev, ..rest] = env
  [
    Dir(
      name: prev.name,
      files: prev.files,
      dirs: [curr, ..prev.dirs],
      size: prev.size + curr.size,
    ),
    ..rest
  ]
}

fn go_down(env, name) {
  [Dir(name: name, files: [], dirs: [], size: 0), ..env]
}

fn file(env, name, size) {
  let new = File(name: name, size: size)
  let [curr, ..rest] = env
  [
    Dir(
      name: curr.name,
      files: [new, ..curr.files],
      dirs: curr.dirs,
      size: size + curr.size,
    ),
    ..rest
  ]
}

fn return_to_root(env: List(Dir)) {
  let [curr, ..] = env
  case curr.name == "/" {
    True -> curr
    False -> return_to_root(go_up(env))
  }
}

fn find_sizes_below(dir: Dir, limit) -> List(Int) {
  let dir_sizes =
    dir.dirs
    |> list.map(fn(dirr) { find_sizes_below(dirr, limit) })
    |> list.flatten()
  case dir.size <= limit {
    True -> [dir.size, ..dir_sizes]
    False -> dir_sizes
  }
}

fn find_sizes_above(dir: Dir, limit) -> List(Int) {
  let dir_sizes =
    dir.dirs
    |> list.map(fn(dirr) { find_sizes_above(dirr, limit) })
    |> list.flatten()
  case dir.size >= limit {
    True -> [dir.size, ..dir_sizes]
    False -> dir_sizes
  }
}
