import * as React from "react";
import Entity from "./Entity";
import AddEntity from "./AddEntity";

export default function Entities(props: { entities: any }) {
  return (
    <>
      <div className="tw-sticky tw-z-10 tw-top-0 tw-p-5 tw-bg-slate-100 tw-grid tw-grid-cols-1 tw-gap-4 sm:tw-grid-cols-2 tw-items-center">
        <AddEntity></AddEntity>
      </div>

      <div className="tw-pt-2 tw-pr-5 tw-pb-5 tw-pl-5 tw-bg-slate-100 tw-grid tw-grid-cols-1 tw-gap-4 sm:tw-grid-cols-2">
        {props.entities && props.entities.map((entity: any, idx: number) => {
          return <Entity key={idx} entity={entity} />
        })}
      </div>
    </>
  )
}
