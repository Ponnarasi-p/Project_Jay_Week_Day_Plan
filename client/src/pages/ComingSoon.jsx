export default function ComingSoon({ title, step }) {
  return (
    <section>
      <h1>{title}</h1>
      <div className="panel muted">
        {step ? `This screen is built in Step ${step} of the plan.` : 'There is no page at this address.'}
      </div>
    </section>
  );
}
