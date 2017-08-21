module Language.Grasp.Generator.GraphViz where

import Prelude
import Data.Foldable (class Foldable, intercalate, foldMap)
import Data.Map as Map
import Data.Map (Map(..))
import Data.Maybe (Maybe(..), maybe)
import Language.Grasp.AST

type NodeStyler = Label -> Maybe NodeStyleRec

digraph :: forall f. Functor f => Foldable f => f GElem1 -> NodeStyler -> String
digraph g styler = "digraph {\n  " <> (intercalate "\n" (fmtGElem1 styler <$> g)) <> "\n}"

fmtGElem1 :: NodeStyler -> GElem1 -> String
fmtGElem1 styler (GNode1 n) = fmtNode styler n
fmtGElem1 styler (GEdge1 e) = fmtEdge styler e

fmtNode :: NodeStyler -> Node -> String
fmtNode styler (Node l) = quote l <> style
  where
    style = foldMap (append " " <<< fmtNodeStyle) (styler l)

fmtEdge :: NodeStyler -> Edge -> String
fmtEdge styler (Edge lMaybe (Node ls) (Node lt)) =
  "  " <> quote ls <> "->" <> quote lt <> maybe "" (\l -> "[label=" <> quote l <> "]") lMaybe

fmtNodeStyle :: NodeStyleRec -> String
fmtNodeStyle l = "["
  <> "color=" <> quote l.color
  <> "]"

quote :: String -> String
quote s = "\"" <> s <> "\""