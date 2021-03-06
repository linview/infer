(*
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd
open! AbstractDomain.Types
module F = Format

module NonZeroInt = struct
  type t = Z.t [@@deriving compare]

  exception DivisionNotExact

  let one = Z.one

  let minus_one = Z.minus_one

  let of_big_int x = if Z.(equal x zero) then None else Some x

  let opt_to_big_int = function None -> Z.zero | Some i -> i

  let is_one = Z.equal one

  let is_minus_one = Z.equal minus_one

  let is_multiple m d = Z.(equal (m mod d) zero)

  let is_negative x = Z.(x < zero)

  let is_positive x = Z.(x > zero)

  let ( ~- ) = Z.( ~- )

  let ( * ) = Z.( * )

  let plus x y = of_big_int Z.(x + y)

  let exact_div_exn num den =
    let q, r = Z.div_rem num den in
    if Z.(equal r zero) then q else raise DivisionNotExact


  let max = Z.max

  let min = Z.min
end

module NonNegativeInt = struct
  type t = Z.t [@@deriving compare]

  let zero = Z.zero

  let one = Z.one

  let is_zero = Z.equal zero

  let is_one = Z.equal one

  let of_big_int i = if Z.(i < zero) then None else Some i

  let of_int_exn i =
    assert (i >= 0) ;
    Z.of_int i


  let of_big_int_exn i =
    assert (Z.(i >= zero)) ;
    i


  let ( <= ) ~lhs ~rhs = lhs <= rhs

  let ( + ) = Z.( + )

  let ( * ) = Z.( * )

  let max = Z.max

  let pp = Z.pp_print
end

module PositiveInt = struct
  type t = NonNegativeInt.t [@@deriving compare]

  let one = Z.one

  let of_big_int i = if Z.(i <= zero) then None else Some i

  let succ = Z.succ

  let pp = Z.pp_print
end
