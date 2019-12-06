/**
  * Copyright (c) 2017 Universitat Politècnica de València (UPV)

  * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

  * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

  * 3. Neither the name of the UPV nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  **/
package sbst.benchmark.pitest;

import java.util.ArrayList;
import java.util.List;

import org.junit.runner.Result;
import org.pitest.mutationtest.engine.MutationIdentifier;

public class MutationResults {

    public enum State { SURVIVED, KILLED, IGNORED, NEVER_RUN }
    
	/** junit results */
	private List<Result> results = new ArrayList<Result>();

	/** ID of the mutation */
	private MutationIdentifier mutation_id;

	private State state;
	
	public MutationResults(List<Result> pResults, MutationIdentifier id){
		this.mutation_id = id;
		this.results = pResults;
		this.state = State.NEVER_RUN;
	}

	public State getState() {
        return state;
    }
	
	public void setState(State state) {
        this.state = state;
    }
	
	public List<Result> getJUnitResults() {
		return results;
	}

	public MutationIdentifier getMutation_id() {
		return mutation_id;
	}

	public void addJUnitResult(Result r){
		this.results.add(r);
	}
	
	

}
