(**************************************************************************)
(*                                                                        *)
(*    Copyright 2012-2015 OCamlPro                                        *)
(*    Copyright 2012 INRIA                                                *)
(*                                                                        *)
(*  All rights reserved.This file is distributed under the terms of the   *)
(*  GNU Lesser General Public License version 3.0 with linking            *)
(*  exception.                                                            *)
(*                                                                        *)
(*  OPAM is distributed in the hope that it will be useful, but WITHOUT   *)
(*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY    *)
(*  or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public        *)
(*  License for more details.                                             *)
(*                                                                        *)
(**************************************************************************)

(** {2 Package name and versions} *)

(** Versions *)
module Version: sig

  include OpamStd.ABSTRACT

  (** Compare two versions using the Debian version scheme *)
  val compare: t -> t -> int
end

(** Names *)
module Name: sig
  include OpamStd.ABSTRACT

  (** Compare two package names *)
  val compare: t -> t -> int

end

type t = private {
  name: Name.t;
  version: Version.t;
}

(** Package (name x version) pairs *)
include OpamStd.ABSTRACT with type t := t

(** Return the package name *)
val name: t -> Name.t

(** Return None if [nv] is not a valid package name *)
val of_string_opt: string -> t option

(** Return the version name *)
val version: t -> Version.t

(** Create a new pair (name x version) *)
val create: Name.t -> Version.t -> t

(** To fit in the GenericPackage type, for generic display functions *)
val name_to_string: t -> string
val version_to_string: t -> string

(** Guess the package name from a filename. This function extracts
    [name] and [version] from {i /path/to/$name.$version/opam}, or
    {i /path/to/$name.$version.opam} *)
val of_filename: OpamFilename.t -> t option

(** Guess the package name from a directory name. This function extracts {i
    $name} and {i $version} from {i /path/to/$name.$version/} *)
val of_dirname: OpamFilename.Dir.t -> t option

(** Guess the package name from an archive file. This function extract
    {i $name} and {i $version} from {i
    /path/to/$name.$version+opam.tar.gz} *)
val of_archive: OpamFilename.t -> t option

(** Convert a set of pairs to a map [name -> versions] *)
val to_map: Set.t -> Version.Set.t Name.Map.t

(** Returns the keys in a package map as a package set *)
val keys: 'a Map.t -> Set.t

(** Extract the versions from a collection of packages *)
val versions_of_packages: Set.t -> Version.Set.t

(** Return the list of versions for a given package *)
val versions_of_name: Set.t -> Name.t -> Version.Set.t

(** Extract the naes from a collection of packages *)
val names_of_packages: Set.t -> Name.Set.t

(** Returns true if the set contains a package with the given name *)
val has_name: Set.t -> Name.t -> bool

(** Return all the packages with the given name *)
val packages_of_name: Set.t -> Name.t -> Set.t

(** Return all the packages with one of the given names *)
val packages_of_names: Set.t -> Name.Set.t -> Set.t

(** Return the maximal available version of a package name from a set.
    Raises [Not_found] if no such package available. *)
val max_version: Set.t -> Name.t -> t

(** Compare two packages *)
val compare: t -> t -> int

(** Are two packages equal ? *)
val equal: t -> t -> bool

(** Hash a package *)
val hash: t -> int

(** Return all the package descriptions in a given directory *)
val list: OpamFilename.Dir.t -> Set.t

(** Return all the package descriptions in the current directory (and
    their eventual prefixes). *)
val prefixes: OpamFilename.Dir.t -> string option Map.t

(** {2 Errors} *)

(** Unknown package: either the name is unknown, or the version does
    not exist. *)
val unknown: Name.t -> Version.t option -> 'a

(** Parallel executions. *)
module Graph: OpamParallel.GRAPH with type V.t = t
