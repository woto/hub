import * as React from "react"

export default function Relevance(props: {relevance: number}) {
  if (props.relevance == null) return;

  const relevanceToString = () => {

    switch (props.relevance) {
      case 0:
        return 'закрепленный'
      case 1:
        return 'основной объект'
      case 2:
        return 'второстепенный объект'
      case 3:
        return 'один из равнозначных'
      case 4:
        return 'ссылающееся издание или автор'
    }
  }

  return (
    <>
      {' '}
      как {relevanceToString()}
    </>
  )
}