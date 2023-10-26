;; Verify that the BB address map is not emitted for empty functions.
; RUN: llc < %s -mtriple=x86_64 -basic-block-sections=labels | FileCheck %s --check-prefixes=CHECK,BASIC
; RUN: llc < %s -mtriple=x86_64 -basic-block-sections=labels -pgo-bb-addr-map=bb-freq | FileCheck %s --check-prefixes=CHECK,PGO

define void @empty_func() {
entry:
  unreachable
}
; CHECK:		{{^ *}}.text{{$}}
; CHECK:	empty_func:
; CHECK:	.Lfunc_begin0:
; BASIC-NOT:	.section	.llvm_bb_addr_map
; PGO-NOT:	.section	.llvm_pgo_bb_addr_map

define void @func() {
entry:
  ret void
}

; CHECK:	func:
; CHECK:	.Lfunc_begin1:
; BASIC:		.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text{{$}}
; PGO:			.section	.llvm_pgo_bb_addr_map,"o",@llvm_pgo_bb_addr_map,.text{{$}}
; CHECK-NEXT:		.byte 2			# version
; BASIC-NEXT:		.byte 0			# feature
; PGO-NEXT:		.byte 2			# feature
; CHECK-NEXT:		.quad	.Lfunc_begin1	# function address
