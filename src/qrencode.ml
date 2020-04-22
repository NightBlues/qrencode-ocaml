type mode =
  | Num
  | Alphanum
  | Data
  | Kanji
  | Structure
  | Eci
  | Fnc1_first
  | Fnc1_second

module QRinput = struct
  type t
  external create : unit -> t = "ocaml_QRinput_new"
  external append : t -> mode -> string -> int = "ocaml_QRinput_append"
end

module QRcode = struct
  type t
  external encode : QRinput.t -> t = "ocaml_QRcode_encodeInput"
  external to_png : t -> int -> int -> string -> unit = "ocaml_writePNG"
  external to_png_string : t -> int -> int -> string = "ocaml_writePNGbuf"
  external width : t -> int = "ocaml_QRcode_width"
  external data : t -> string = "ocaml_QRcode_data"

  let to_png t ~size ~margin ~outfile = to_png t size margin outfile
  let to_png_string t ~size ~margin = to_png_string t size margin
end

module Basic = struct
  let encode data ?(size=4) ?(margin=3) outfile =
    let input = QRinput.create () in
    match QRinput.append input Data data with
    | 0 ->
      let code = QRcode.encode input in
      QRcode.to_png code ~size ~margin ~outfile
    | _ -> failwith "encode"

end
