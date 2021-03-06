{-# OPTIONS --rewriting #-}

open import SkMults

module Sound where --(M : SkMult) where

open import Data.Empty
open import Data.Maybe renaming (map to mmap)
open import Data.Sum
open import Data.Unit
open import Data.List
open import Data.Product hiding (uncurry;curry)
open import Relation.Binary.PropositionalEquality hiding (_≗_)
open ≡-Reasoning
open import Utilities
open import Formulae 
open import FreeSkewProunitalClosed 
open import SeqCalc 

-- ====================================================================

[_∣id]f : ∀ Γ {C} → [ Γ ∣ id {C} ]f ≐ id
[ [] ∣id]f = refl
[ A ∷ Γ ∣id]f = (refl ⊸ [ Γ ∣id]f) ∙ f⊸id

[_∣∘]f : (Γ : Cxt) {B C D : Fma} → {f : just B ⇒ C} {g : just C ⇒ D}
  → [ Γ ∣ g ∘ f ]f ≐ [ Γ ∣ g ]f ∘ [ Γ ∣ f ]f
[ [] ∣∘]f = refl
[ A ∷ Γ ∣∘]f = (refl ⊸ [ Γ ∣∘]f) ∙ (rid ⊸ refl) ∙ f⊸∘

[_∣≐]f : (Γ : Cxt) {B C : Fma} → {f g : just B ⇒ C}
  → f ≐ g → [ Γ ∣ f ]f ≐ [ Γ ∣ g ]f
[ [] ∣≐]f p = p
[ A ∷ Γ ∣≐]f p = refl ⊸ [ Γ ∣≐]f p

nL⋆ : ∀ Γ {A}{B}{C} (g : just B ⇒ C)
  → L⋆ Γ ∘ g ⊸ id {A} ≐ [ Γ ∣ g ]f ⊸ id ∘ L⋆ Γ
nL⋆ [] g = lid ∙ rid
nL⋆ (_ ∷ Γ) g = 
  proof≐
    L ∘ L⋆ Γ ∘ g ⊸ id
  ≐〈 ass 〉
    L ∘ (L⋆ Γ ∘ g ⊸ id)
  ≐〈 refl ∘ nL⋆ Γ g 〉
    L ∘ ([ Γ ∣ g ]f ⊸ id ∘ L⋆ Γ)
  ≐〈 (~ ass) ∙ (~ lid ∘ refl ∘ refl) 〉
    id ∘ L ∘ [ Γ ∣ g ]f ⊸ id ∘ L⋆ Γ
  ≐〈 ~ (refl ⊸ f⊸id ∙ f⊸id) ∘ refl ∘ refl ∘ refl 〉 
    id ⊸ (id ⊸ id) ∘ L ∘ [ Γ ∣ g ]f ⊸ id ∘ L⋆ Γ
  ≐〈 (~ nL) ∘ refl 〉
    id ⊸ [ Γ ∣ g ]f ⊸ (id ⊸ id) ∘ L ∘ L⋆ Γ
  ≐〈 refl ⊸ f⊸id ∘ refl ∘ refl 〉
    id ⊸ [ Γ ∣ g ]f ⊸ id ∘ L ∘ L⋆ Γ
  ≐〈 ass 〉
    id ⊸ [ Γ ∣ g ]f ⊸ id ∘ (L ∘ L⋆ Γ)
  qed≐

nL⋆2 : ∀ Γ {A}{B}{C} (g : just B ⇒ C)
  → L⋆ Γ ∘ id {A} ⊸ g ≐ id ⊸ [ Γ ∣ g ]f ∘ L⋆ Γ
nL⋆2 [] g = lid ∙ rid
nL⋆2 (_ ∷ Γ) g =
  proof≐
    L ∘ L⋆ Γ ∘ id ⊸ g
  ≐〈 ass 〉
    L ∘ (L⋆ Γ ∘ id ⊸ g)
  ≐〈 refl ∘ nL⋆2 Γ g 〉
    L ∘ (id ⊸ [ Γ ∣ g ]f ∘ L⋆ Γ)
  ≐〈 (~ ass) ∙ (~ lid ∘ refl ∘ refl) 〉
    id ∘ L ∘ id ⊸ [ Γ ∣ g ]f ∘ L⋆ Γ
  ≐〈 ~ (refl ⊸ f⊸id ∙ f⊸id) ∘ refl ∘ refl ∘ refl 〉
    id ⊸ (id ⊸ id) ∘ L ∘ id ⊸ [ Γ ∣ g ]f ∘ L⋆ Γ
  ≐〈 (~ nL) ∘ refl 〉
    (id ⊸ id) ⊸ (id ⊸ [ Γ ∣ g ]f) ∘ L ∘ L⋆ Γ
  ≐〈 f⊸id ⊸ refl ∘ refl ∘ refl 〉
    id ⊸ (id ⊸ [ Γ ∣ g ]f) ∘ L ∘ L⋆ Γ
  ≐〈 ass 〉
    id ⊸ (id ⊸ [ Γ ∣ g ]f) ∘ (L ∘ L⋆ Γ)
  qed≐


φf : ∀ Γ Δ {A}{B} {g : just A ⇒ B}
  → [ Γ ++ Δ ∣ g ]f ≡ [ Γ ∣ [ Δ ∣ g ]f ]f
φf [] Δ = refl
φf (A ∷ Γ) Δ = cong (_⊸_ id) (φf Γ Δ)

{-# REWRITE φf #-}


L⋆LL⋆ : ∀ Γ Δ Λ {A} {B} {C}
  → L⋆ Γ ⊸ id ∘ L ∘ L⋆ (Γ ++ Λ) ≐ id ⊸ L⋆ Γ ∘ L {B} ∘ L⋆ Λ {A}{[ Δ ∣ C ]}
L⋆LL⋆ [] Δ Λ = refl
L⋆LL⋆ (B ∷ Γ) Δ Λ = 
  proof≐
    (L ∘ L⋆ Γ) ⊸ id ∘ L ∘ (L ∘ L⋆ (Γ ++ Λ))
  ≐〈 ∘⊸id ∘ refl ∘ refl 〉
    L⋆ Γ ⊸ id ∘ L ⊸ id ∘ L ∘ (L ∘ L⋆ (Γ ++ Λ))
  ≐〈 (~ ass) ∙ ((ass ∘ refl) ∙ ass ∘ refl) 〉
    L⋆ Γ ⊸ id ∘ (L ⊸ id ∘ L ∘ L) ∘ L⋆ (Γ ++ Λ)
  ≐〈 refl ∘ (~ LLL) ∘ refl 〉
    L⋆ Γ ⊸ id ∘ (id ⊸ L ∘ L) ∘ L⋆ (Γ ++ Λ)
  ≐〈 (~ ass) ∘ refl 〉
    L⋆ Γ ⊸ id ∘ id ⊸ L ∘ L ∘ L⋆ (Γ ++ Λ)
  ≐〈 swap⊸ ∘ refl ∘ refl 〉
    id ⊸ L ∘ L⋆ Γ ⊸ id ∘ L ∘ L⋆ (Γ ++ Λ)
  ≐〈 (ass ∘ refl) ∙ ass 〉
    id ⊸ L ∘ (L⋆ Γ ⊸ id ∘ L ∘ L⋆ (Γ ++ Λ))
  ≐〈 refl ∘ L⋆LL⋆ Γ Δ Λ 〉
    id ⊸ L ∘ (id ⊸ L⋆ Γ ∘ L ∘ L⋆ Λ)
  ≐〈 (~ ass) ∙ (~ ass ∘ refl) 〉
    id ⊸ L ∘ id ⊸ L⋆ Γ ∘ L ∘ L⋆ Λ
  ≐〈 ~( id⊸∘) ∘ refl ∘ refl 〉
    id ⊸ (L ∘ L⋆ Γ) ∘ L ∘ L⋆ Λ
  qed≐

L⋆-j : ∀ Γ {C} → L⋆ Γ ∘ j {C} ≐ j 
L⋆-j [] = lid
L⋆-j (A ∷ Γ) =
  proof≐
    L ∘ L⋆ Γ ∘ j
  ≐〈 ass 〉
    L ∘ (L⋆ Γ ∘ j)
  ≐〈 refl ∘ L⋆-j Γ 〉
    L ∘ j
  ≐〈 Lj 〉
    j
  qed≐

L⋆ass : ∀ Γ Δ {A}{B} → L⋆ (Γ ++ Δ) {A}{B} ≐ L⋆ Γ ∘ L⋆ Δ
L⋆ass [] Δ = ~ lid
L⋆ass (C ∷ Γ) Δ = (refl ∘ L⋆ass Γ Δ) ∙ (~ ass)

-- soundness

sound : {S : Stp} → {Γ : Cxt} → {A : Fma} → S ∣ Γ ⊢ A → S ⇒ [ Γ ∣ A ]
sound (uf f) = id ⊸ sound f ∘ j
sound (⊸r {S}{Γ}{A}{B} f) = sound f
sound (⊸l {Γ} f g) = i (sound f) ∘ L⋆ Γ ∘ id ⊸ sound g
sound (base f eq eq2) = base f eq eq2
sound (⊸c Δ₀ {Γ} f g) = [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f) ⊸ id ∘ L⋆ Γ ]f ∘ sound g

-- sound preserves equality

≗sound≐ : ∀ {S Γ A} {f g : S ∣ Γ ⊢ A}
  → f ≗ g → sound f ≐ sound g
≗sound≐ refl = refl
≗sound≐ (~ p) = ~ (≗sound≐ p)
≗sound≐ (p ∙ p₁) = (≗sound≐ p) ∙ (≗sound≐ p₁)
≗sound≐ (uf p) = refl ⊸ ≗sound≐ p ∘ refl
≗sound≐ (⊸r p) = ≗sound≐ p
≗sound≐ (⊸l p p₁) =
  i (≗sound≐ p) ∘ refl ∘ (refl ⊸ ≗sound≐ p₁)
≗sound≐ ⊸ruf = refl
≗sound≐ ⊸r⊸l = refl
≗sound≐ (⊸c Δ₀ p q) =
  [ Δ₀ ∣≐]f (refl ∘ i (≗sound≐ p) ⊸ refl ∘ refl) ∘ ≗sound≐ q
≗sound≐ ⊸r⊸c = refl
≗sound≐ ⊸cuf =
  ~ ass
  ∙ (~ f⊸∘ ∙ lid ⊸ refl ∘ refl)
≗sound≐ (⊸c⊸l {Γ} {Δ} {Γ'} {f = f} {f'} {g}) =
  proof≐
    [ Γ ++ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ∘
      (i (sound f) ∘ L⋆ Γ ∘ (id ⊸ sound g))
  ≐〈 ~ ass ∙ (~ ass ∘ refl) 〉
    [ Γ ∣ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f ∘
      i (sound f)
        ∘ L⋆ Γ ∘  id ⊸ sound g
  ≐〈 ni2 ∘ refl ∘ refl 〉 
    i (sound f) ∘
      (id ⊸ [ Γ ∣ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f)
        ∘ L⋆ Γ ∘  id ⊸ sound g
  ≐〈 ass ∘ refl 〉 
    i (sound f) ∘
      ((id ⊸ [ Γ ∣ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f)
        ∘ L⋆ Γ) ∘ 
        id ⊸ sound g
  ≐〈 refl ∘ ~ nL⋆2 Γ _ ∘ refl 〉 
    i (sound f) ∘
      (L⋆ Γ ∘ id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f) ∘
        id ⊸ sound g
  ≐〈 ~ ass ∘ refl 〉 
    i (sound f) ∘ L⋆ Γ ∘
      (id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f) ∘
        id ⊸ sound g
  ≐〈 ass 〉 
    i (sound f) ∘ L⋆ Γ ∘
      ((id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f) ∘
        (id ⊸ sound g))
  ≐〈 refl ∘ ~ f⊸∘ 〉 
    i (sound f) ∘ L⋆ Γ ∘
      ((id  ∘ id) ⊸
       ([ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ∘ sound g))
  ≐〈 refl ∘ lid ⊸ refl 〉 
    i (sound f) ∘ L⋆ Γ ∘
      (id ⊸
       ([ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ∘ sound g))
  qed≐
≗sound≐ (⊸c⊸c {Γ = Γ} {Γ'} {Δ₀} {Δ₁} {A = A} {B} {f = f} {f'} {g}) =
  proof≐
    [ Δ₀ ++ A ⊸ B ∷ Γ ++ Δ₁ ∣
      (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f
      ∘ ([ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ L⋆ Γ ]f ∘ sound g)
  ≐〈 ~ ass 〉 
    [ Δ₀ ∣ id ⊸  [ Γ ++ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f
      ∘ [ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ L⋆ Γ ]f ∘ sound g
  ≐〈 ~ [ Δ₀ ∣∘]f ∙ [ Δ₀ ∣≐]f (~ ass ∙ (~ ass ∘ refl)) ∘ refl 〉 
    [ Δ₀ ∣ id ⊸  [ Γ ++ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f 
      ∘ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ L⋆ Γ ]f ∘ sound g
  ≐〈 [ Δ₀ ∣≐]f (~ swap⊸ ∘ refl ∙ (ass ∙ (refl ∘
       (~ swap⊸ ∙ (refl ∘ refl ⊸ refl)) ∙ ~ ass))
         ∘ refl) ∘ refl 〉 
    [ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘
      (id ⊸ [ Γ ∣ [ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f)
        ∘ L⋆ Γ ]f ∘
       sound g
  ≐〈 [ Δ₀ ∣≐]f (ass ∙ (refl ∘ ~ nL⋆2 Γ _)) ∘ refl 〉 
    [ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ (L⋆ Γ ∘
      id ⊸ [ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f) ]f ∘
       sound g
  ≐〈 [ Δ₀ ∣≐]f (~ ass) ∘ refl 〉 
    [ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ L⋆ Γ ∘
      id ⊸ [ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f ∘
       sound g
  ≐〈 [ Δ₀ ∣∘]f ∘ refl 〉 
    [ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ L⋆ Γ ]f ∘
      [ Δ₀ ∣ id ⊸ [ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ]f ∘
       sound g
  ≐〈 ass 〉 
    [ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f) ⊸ id) ∘ L⋆ Γ ]f ∘
      ([ Δ₀ ++ B ∷ Δ₁ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f ∘
       sound g)
  qed≐
≗sound≐ baseuf = baseuf
≗sound≐ (⊸cuf2 {Γ} {f = f} {g}) =
  proof≐
    L⋆ Γ ⊸ id ∘ i (sound f) ⊸ id ∘ L⋆ Γ ∘ ((id ⊸ sound g) ∘ j)
  ≐〈 ~ ass ∙ (ass ∘ refl) 〉
    L⋆ Γ ⊸ id ∘ i (sound f) ⊸ id ∘ (L⋆ Γ ∘ id ⊸ sound g) ∘ j
  ≐〈 refl ∘ nL⋆2 Γ _ ∘ refl 〉
    L⋆ Γ ⊸ id ∘ i (sound f) ⊸ id ∘ (id ⊸ [ Γ ∣ sound g ]f ∘ L⋆ Γ) ∘ j
  ≐〈 ~ ass ∘ refl ∙ ass 〉
    L⋆ Γ ⊸ id ∘ i (sound f) ⊸ id ∘ id ⊸ [ Γ ∣ sound g ]f ∘ (L⋆ Γ ∘ j)
  ≐〈 refl ∘ L⋆-j Γ 〉
    L⋆ Γ ⊸ id ∘ i (sound f) ⊸ id ∘ id ⊸ [ Γ ∣ sound g ]f ∘ j
  ≐〈 ass ∘ refl ∙ ass 〉
    L⋆ Γ ⊸ id ∘ (i (sound f) ⊸ id ∘ id ⊸ [ Γ ∣ sound g ]f ∘ j)
  ≐〈 refl ∘ (ass ∙ (refl ∘ ~ nj) ∙ ~ ass) 〉
    L⋆ Γ ⊸ id ∘ (i (sound f) ⊸ id ∘ [ Γ ∣ sound g ]f ⊸ id ∘ j)
  ≐〈 refl ∘ (~ ∘⊸id  ∘ refl) 〉
    L⋆ Γ ⊸ id ∘ (([ Γ ∣ sound g ]f ∘ i (sound f)) ⊸ id ∘ j)
  ≐〈 refl ∘ (ni2 ⊸ refl ∘ refl) 〉
    L⋆ Γ ⊸ id ∘ ((i (sound f) ∘ id ⊸ [ Γ ∣ sound g ]f) ⊸ id ∘ j)
  ≐〈 refl ∘ (∘⊸id ∘ refl) 〉
    L⋆ Γ ⊸ id ∘ (id ⊸ [ Γ ∣ sound g ]f ⊸ id ∘ i (sound f) ⊸ id ∘ j)
  ≐〈 ~ ass ∙ (~ ass ∘ refl) 〉
    L⋆ Γ ⊸ id ∘ id ⊸ [ Γ ∣ sound g ]f ⊸ id ∘ i (sound f) ⊸ id ∘ j
  ≐〈 ~ ∘⊸id  ∘ refl ∘ refl 〉
    (id ⊸ [ Γ ∣ sound g ]f ∘ L⋆ Γ) ⊸ id ∘ i (sound f) ⊸ id ∘ j
  ≐〈 ~ ∘⊸id ∘ refl 〉
    (i (sound f) ∘ ((id ⊸ [ Γ ∣ sound g ]f) ∘ L⋆ Γ)) ⊸ id ∘ j
  ≐〈 (refl ∘ ~ (nL⋆2 Γ _)) ⊸ refl ∘ refl 〉
    (i (sound f) ∘ (L⋆ Γ ∘ (id ⊸ sound g))) ⊸ id ∘ j
  ≐〈 (~ ass) ⊸ refl ∘ refl 〉
    (i (sound f) ∘ L⋆ Γ ∘ (id ⊸ sound g)) ⊸ id ∘ j
  ≐〈 nj 〉
    id ⊸ (i (sound f) ∘ L⋆ Γ ∘ (id ⊸ sound g)) ∘ j
  qed≐
≗sound≐ (⊸c⊸l2 {Γ = Γ} {Δ = Δ} {Γ'} {Λ} {A' = A} {B' = B} {f = f} {f'} {g}) =
  proof≐
    [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ∘ (i (sound f) ∘ L⋆ (Δ ++ B ∷ Λ) ∘ (id ⊸ sound g))
  ≐〈 ~ ass ∙ (~ ass ∘ refl) 〉 
    [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ∘ i (sound f) ∘ L⋆ (Δ ++ B ∷ Λ) ∘ (id ⊸ sound g)
  ≐〈 ni2 ∘ refl ∘ refl 〉 
    i (sound f) ∘ id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ∘ L⋆ (Δ ++ B ∷ Λ) ∘ (id ⊸ sound g)
  ≐〈 ass ∘ refl 〉 
    i (sound f) ∘ (id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ∘ L⋆ (Δ ++ B ∷ Λ)) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (refl ∘ L⋆ass Δ (B ∷ Λ)) ∘ refl 〉 
    i (sound f) ∘ (id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ∘ (L⋆ Δ ∘ (L ∘ L⋆ Λ))) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (~ ass ∙ ~ ass) ∘ refl 〉 
    i (sound f) ∘ (id ⊸ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ∘ L⋆ Δ ∘ L ∘ L⋆ Λ) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (~ nL⋆2 Δ _  ∘ refl ∘ refl) ∘ refl 〉 
    i (sound f) ∘ (L⋆ Δ ∘ id ⊸ ((L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ') ∘ L ∘ L⋆ Λ) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (ass ∘ refl ∙ ass) ∘ refl 〉 
    i (sound f) ∘ (L⋆ Δ ∘ (id ⊸ ((L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ') ∘ L ∘ L⋆ Λ)) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (refl ∘ lem) ∘ refl 〉 
    i (sound f) ∘ (L⋆ Δ ∘ (((L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ') ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ))) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (~ ass ∙ (~ ass ∘ refl)) ∘ refl 〉 
    i (sound f) ∘ (L⋆ Δ ∘ ((L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ') ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (nL⋆ Δ _ ∘ refl ∘ refl) ∘ refl 〉 
    i (sound f) ∘ ([ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ⊸ id ∘ L⋆ Δ ∘ L ∘ L⋆ (Γ' ++ Λ)) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (ass ∙ ass) ∘ refl 〉 
    i (sound f) ∘ ([ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ⊸ id ∘ (L⋆ Δ ∘ (L ∘ L⋆ (Γ' ++ Λ)))) ∘ (id ⊸ sound g)
  ≐〈 refl ∘ (refl ∘ ~ (L⋆ass Δ (_ ∷ Γ' ++ Λ))) ∘ refl 〉 
    i (sound f) ∘ ([ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ⊸ id ∘ L⋆ (Δ ++ A ⊸ B ∷ Γ' ++ Λ)) ∘ (id ⊸ sound g)
  ≐〈 ~ ass ∘ refl 〉 
    i (sound f) ∘ [ Δ ∣ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ' ]f  ⊸ id ∘ L⋆ (Δ ++ A ⊸ B ∷ Γ' ++ Λ) ∘ (id ⊸ sound g)
  ≐〈 ni1 ∘ refl ∘ refl 〉 
    i (_ ∘ sound f) ∘ L⋆ (Δ ++ A ⊸ B ∷ Γ' ++ Λ) ∘ (id ⊸ sound g)
  qed≐
  where
    lem : id ⊸ (L⋆ Γ' ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ') ∘ L ∘ L⋆ Λ
             ≐ (L⋆ Γ' ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
    lem =
      proof≐
        id ⊸ (L⋆ Γ' ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ') ∘ L ∘ L⋆ Λ
      ≐〈 id⊸∘ ∘ refl ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id ∘ i (sound f') ⊸ id) ∘ id ⊸ L⋆ Γ' ∘ L ∘ L⋆ Λ
      ≐〈 (refl ⊸ (~ ∘⊸id)) ∘ refl ∘ refl ∙ ass ∘ refl ∙ ass 〉
        id ⊸ ((i (sound f') ∘ L⋆ Γ') ⊸ id) ∘ (id ⊸ L⋆ Γ' ∘ L ∘ L⋆ Λ)
      ≐〈 refl ∘ ~ L⋆LL⋆ Γ' Γ Λ 〉
        id ⊸ ((i (sound f') ∘ L⋆ Γ') ⊸ id) ∘ ((L⋆ Γ' ⊸ id) ∘ L ∘ L⋆ (Γ' ++ Λ))
      ≐〈 ~ ass ∙ (~ ass ∘ refl)  〉
        id ⊸ ((i (sound f') ∘ L⋆ Γ') ⊸ id) ∘ L⋆ Γ' ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈  refl ⊸ ∘⊸id ∘ refl ∘ refl ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id ∘ i (sound f') ⊸ id) ∘ L⋆ Γ' ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈  id⊸∘ ∘ refl ∘ refl ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id) ∘ id ⊸ (i (sound f') ⊸ id) ∘ L⋆ Γ' ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈  ass ∙ (refl ∘ ~ swap⊸) ∙ ~ ass ∘ refl ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id) ∘ L⋆ Γ' ⊸ id ∘ (id ⊸ (i (sound f') ⊸ id)) ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈 ass ∙ (refl ∘ (rid ∙ (refl ∘ ~ f⊸id))) ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id) ∘ L⋆ Γ' ⊸ id ∘ ((id ⊸ (i (sound f') ⊸ id)) ∘ L ∘ (id ⊸ id)) ∘ L⋆ (Γ' ++ Λ)
      ≐〈  refl ∘ ~ nL ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id) ∘ L⋆ Γ' ⊸ id ∘ ((i (sound f') ⊸ id) ⊸ (id ⊸ id) ∘ L) ∘ L⋆ (Γ' ++ Λ)
      ≐〈 ~ ass ∙ (ass ∙ (refl ∘ (refl ∘ (refl ⊸ f⊸id) ∙ ~ ∘⊸id)) ∘ refl)  ∘ refl 〉
        id ⊸ (L⋆ Γ' ⊸ id) ∘ (i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈 ~ swap⊸ ∘ refl  ∘ refl 〉
        (i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ id ⊸ (L⋆ Γ' ⊸ id) ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈 ass ∙ (refl ∘ (rid ∙ (refl ∘ ~ f⊸id))) ∘ refl 〉
        (i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ ((id ⊸ (L⋆ Γ' ⊸ id)) ∘ L ∘ (id ⊸ id)) ∘ L⋆ (Γ' ++ Λ)
      ≐〈 refl ∘ ~ nL ∘ refl 〉
        (i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ ((L⋆ Γ' ⊸ id) ⊸ (id ⊸ id) ∘ L) ∘ L⋆ (Γ' ++ Λ)
      ≐〈 ~ ass ∙ (refl ∘ refl ⊸ f⊸id ∘ refl) ∘ refl 〉
        (i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ (L⋆ Γ' ⊸ id) ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
      ≐〈 ~ ∘⊸id ∙ ~ ass ⊸ refl  ∘ refl ∘ refl 〉
        (L⋆ Γ' ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ') ⊸ id ∘ L ∘ L⋆ (Γ' ++ Λ)
      qed≐
≗sound≐ (⊸c⊸c2 {Γ = Γ} {Δ₀} {Δ₁} {Δ₂} {Δ₃} {B = B} {f = f} {f'}) = ~ ass ∙ (~ [ Δ₂ ∣∘]f ∙ [ Δ₂ ∣≐]f lem ∘ refl)
  where
    lem' : _
    lem' =
      proof≐ 
        id ⊸ [ Δ₀ ∣ (i (sound f') ∘ L⋆ Γ) ⊸ id ∘ L⋆ Γ ]f ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)
      ≐〈 refl ∘ L⋆ass Δ₀ (B ∷ Δ₁) ∙ (~ ass ∙ ~ ass) 〉 
        id ⊸ [ Δ₀ ∣ (i (sound f') ∘ L⋆ Γ) ⊸ id ∘ L⋆ Γ ]f ∘ L⋆ Δ₀ ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ~ nL⋆2 Δ₀ _ ∘ refl ∘ refl 〉 
        L⋆ Δ₀ ∘ id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id ∘ L⋆ Γ) ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 refl ∘ id⊸∘ ∙ ~ ass ∘ refl ∘ refl 〉 
        L⋆ Δ₀ ∘ id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ id ⊸ L⋆ Γ ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ass ∘ refl ∙ ass 〉 
        L⋆ Δ₀ ∘ id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ (id ⊸ L⋆ Γ ∘ L {B} ∘ L⋆ Δ₁)
      ≐〈 refl ∘ ~ L⋆LL⋆ Γ [] Δ₁ 〉 
        L⋆ Δ₀ ∘ id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ (L⋆ Γ ⊸ id ∘ L {[ Γ ∣ B ]} ∘ L⋆ (Γ ++ Δ₁))
      ≐〈 ~ ass ∙ (~ ass ∘ refl) 〉 
        L⋆ Δ₀ ∘ id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L⋆ Γ ⊸ id ∘ L {[ Γ ∣ B ]} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∙ (refl ∘ ~ swap⊸) ∙ ~ ass ∘ refl ∘ refl 〉 
        L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L {[ Γ ∣ B ]} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∘ refl 〉 
        L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ (id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L {[ Γ ∣ B ]}) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ (rid ∙ (refl ∘ ~ f⊸id)) ∘ refl 〉 
        L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ (id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L {[ Γ ∣ B ]} ∘ id ⊸ id) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ ~ nL ∘ refl 〉 
        L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ ((((i (sound f') ∘ L⋆ Γ) ⊸ id) ⊸ (id ⊸ id)) ∘ L {_ ⊸ B}) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ ((refl ⊸ f⊸id) ∘ refl) ∘ refl 〉 
        L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ ((((i (sound f') ∘ L⋆ Γ) ⊸ id) ⊸ id) ∘ L {_ ⊸ B}) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ~ ass ∘ refl 〉 
        L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ (i (sound f') ∘ L⋆ Γ) ⊸ id ⊸ id ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∘ refl ∘ refl 〉 
        L⋆ Δ₀ ∘ (L⋆ Γ ⊸ id ∘ (i (sound f') ∘ L⋆ Γ) ⊸ id ⊸ id) ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ (~ ∘⊸id ∙ (∘⊸id ∘ refl) ⊸ refl) ∘ refl ∘ refl 〉 
        L⋆ Δ₀ ∘ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ) ⊸ id ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 nL⋆ Δ₀ _ ∘ refl ∘ refl 〉 
        [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∙ ass ∙ (refl ∘ ~ L⋆ass Δ₀ (_ ∷ Γ ++ Δ₁)) 〉 
        [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ⊸ id ∘ L⋆ (Δ₀ ++ _ ⊸ B ∷ Γ ++ Δ₁)
      qed≐
    
    lem : _
    lem =
      proof≐
        id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ (L⋆ (Δ₀ ++ B ∷ Δ₁) ⊸ id ∘ i (sound f) ⊸ id ∘ L⋆ (Δ₀ ++ B ∷ Δ₁))
      ≐〈 refl ∘ (~ ∘⊸id ∘ refl) 〉 
        id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ ((i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ (Δ₀ ++ B ∷ Δ₁))
      ≐〈 ~ ass 〉 
        id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)
      ≐〈 refl ∘ L⋆ass Δ₀ (B ∷ Δ₁) ∙ (~ ass) 〉 
        id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ (L {B} ∘ L⋆ Δ₁)
      ≐〈 ~ ass 〉 
        id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ~ swap⊸ ∘ refl ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ L⋆ Δ₀ ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ass ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ (id ⊸ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ∘ L⋆ Δ₀) ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 refl ∘ ~ nL⋆2 Δ₀ _ ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ (L⋆ Δ₀ ∘ (id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ))) ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ~ ass ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ) ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ass ∙ (refl ∘ (refl ∘ id⊸∘) ∙ ~ ass ∙ ~ ass) ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id) ∘ id ⊸ L⋆ Γ ∘ L {B} ∘ L⋆ Δ₁
      ≐〈 ass ∘ refl ∙ ass 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id) ∘ (id ⊸ L⋆ Γ ∘ L {B} ∘ L⋆ Δ₁)
      ≐〈 refl ∘ ~ L⋆LL⋆ Γ Δ₃ Δ₁ 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id) ∘ ((L⋆ Γ ⊸ id) ∘ L ∘ L⋆ (Γ ++ Δ₁))
      ≐〈 ~ ass ∙ (~ ass ∘ refl) 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id) ∘ L⋆ Γ ⊸ id ∘ L {[ Γ ∣ B ]} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∙ (refl ∘ ~ swap⊸) ∙ ~ ass ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ id ⊸ (L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id) ∘ L {[ Γ ∣ B ]} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∙ (refl ∘ (refl ∘ refl ⊸ (~ ∘⊸id))) ∙ ~ ass ∘ refl ∙ ass ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ (id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L {[ Γ ∣ B ]}) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ (rid ∙ (refl ∘ ~ f⊸id)) ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ (id ⊸ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L {[ Γ ∣ B ]} ∘ id ⊸ id) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ ~ nL ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ ((((i (sound f') ∘ L⋆ Γ) ⊸ id) ⊸ (id ⊸ id)) ∘ L {_ ⊸ B}) ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ~ ass ∙ (refl ∘ refl ⊸ f⊸id ∘ refl) ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L⋆ Γ ⊸ id ∘ (i (sound f') ∘ L⋆ Γ) ⊸ id ⊸ id ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∙ (refl ∘ ~ ∘⊸id) ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ ((i (sound f') ∘ L⋆ Γ) ⊸ id ∘ L⋆ Γ) ⊸ id ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ (L⋆ Δ₀ ∘ ((i (sound f') ∘ L⋆ Γ) ⊸ id ∘ L⋆ Γ) ⊸ id) ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ nL⋆ Δ₀ _ ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ ([ Δ₀ ∣ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L⋆ Γ ]f ⊸ id ∘ L⋆ Δ₀) ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ~ ass ∘ refl ∘ refl 〉 
        (i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ [ Δ₀ ∣ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L⋆ Γ ]f ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ~ ∘⊸id ∙ ~ ass ⊸ refl ∘ refl ∘ refl ∘ refl 〉 
        ([ Δ₀ ∣ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L⋆ Γ ]f ∘ i (sound f) ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 (ni2 ∘ refl) ⊸ refl ∘ refl ∘ refl ∘ refl 〉 
        (i (sound f) ∘ id ⊸ [ Δ₀ ∣ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L⋆ Γ ]f ∘ L⋆ (Δ₀ ++ B ∷ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass ⊸ refl ∘ refl ∘ refl ∘ refl 〉 
        (i (sound f) ∘ (id ⊸ [ Δ₀ ∣ ((i (sound f') ∘ L⋆ Γ) ⊸ id) ∘ L⋆ Γ ]f ∘ L⋆ (Δ₀ ++ B ∷ Δ₁))) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 (refl ∘ lem') ⊸ refl ∘ refl ∘ refl ∘ refl 〉 
        (i (sound f) ∘ ([ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ⊸ id ∘ L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁))) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 (~ ass) ⊸ refl ∘ refl ∘ refl ∘ refl 〉 
        (i (sound f) ∘ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ⊸ id ∘ L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁)) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ∘⊸id ∘ refl ∘ refl ∘ refl 〉 
        L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁) ⊸ id ∘ (i (sound f) ∘ [ Δ₀ ∣ L⋆ Γ ⊸ id ∘ i (sound f') ⊸ id ∘ L⋆ Γ ]f ⊸ id) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 refl ∘ (ni1 ⊸ refl) ∘ refl ∘ refl ∘ refl 〉 
        L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁) ⊸ id ∘ i ([ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ ]f ∘ sound f) ⊸ id ∘ L⋆ Δ₀ ∘ L {_ ⊸ B} ∘ L⋆ (Γ ++ Δ₁)
      ≐〈 ass 〉 
        L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁) ⊸ id ∘ i ([ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ ]f ∘ sound f) ⊸ id ∘ L⋆ Δ₀ ∘ (L {_ ⊸ B} ∘ (L⋆ (Γ ++ Δ₁)))
      ≐〈 ass ∙ (refl ∘ ~ L⋆ass Δ₀ (_ ∷ Γ ++ Δ₁)) 〉 
        L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁) ⊸ id ∘ i ([ Δ₀ ∣ (L⋆ Γ ⊸ id) ∘ (i (sound f') ⊸ id) ∘ L⋆ Γ ]f ∘ sound f) ⊸ id ∘ L⋆ (Δ₀ ++ _ ∷ Γ ++ Δ₁)
      qed≐

  


